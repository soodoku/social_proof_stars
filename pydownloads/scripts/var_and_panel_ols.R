# Loads libs
library(readr)
library(vars)
library(reshape2)
library(dplyr)
library(dyn)

# Load dat
bq_50k <- read_csv("../data/pydownloads/bq-results-20230603-222533-1685831182985.csv")

# recode to bot or not

bq_50k <- bq_50k %>%
  mutate(bot_or_not = case_when(
    installer_name == "pip" ~ "human",
    installer_name == "Browser" ~ "bot",
    installer_name == "bandersnatch" ~ "bot",
    installer_name == "setuptools" ~ "human",
    installer_name == "Nexus" ~ "human",
    installer_name == "requests" ~ "bot",
    installer_name == "devpi" ~ "bot",
    installer_name == "pdm" ~ "human",
    installer_name == "Homebrew" ~ "human",
    installer_name == "Artifactory" ~ "human",
    installer_name == "OS" ~ "human",
    installer_name == "Bazel" ~ "human",
    installer_name == "pex" ~ "human",
    installer_name == "conda" ~ "human",
    installer_name == "chaquopy" ~ "human",
    TRUE ~ NA_character_
  ))

# Remove the 'installer_name' column
bq_50k <- select(bq_50k, -installer_name)

# Fill missing values in 'bot_or_not' column with 'bot'
bq_50k$bot_or_not <- ifelse(is.na(bq_50k$bot_or_not), "bot", bq_50k$bot_or_not)

# Convert the dataframe to wide format
wide_df <- dcast(bq_50k, timestamp_date + file_project ~ bot_or_not, value.var = "downloads", fill = 0)

# Print the resulting wide dataframe
print(wide_df)

# Convert the data frame to a time series object
ts_data <- ts(wide_df %>% select("bot", "human"), frequency = 1)

# VARselect(var_model)$selection
# Run the VAR model with automatic lag selection
var_model <- VAR(ts_data, ic = "AIC", lag.max = 20, type = "both")

# Perform the Granger causality test
granger_test <- causality(var_model, cause = "bot")

# Print the test results
print(granger_test)


# Load the plm package
library(plm)

# Convert the time variable to a date format
wide_df$timestamp_date <- as.Date(wide_df$timestamp_date)

# Create a panel data object
pdata <- pdata.frame(wide_df, index = c("file_project", "timestamp_date"))

# Create lagged variables
pdata$bot_lag <- lag(pdata$bot)

# Perform the panel OLS regression with fixed effects
model <- plm(human ~ bot_lag, data = pdata, model = "within")

# Display the regression results
summary(model)

# Create lagged variables for 'human'
max_lag <- 3
for (lag in 1:max_lag) {
  wide_df <- wide_df %>% group_by(file_project) %>% mutate(human_lag = lag(human, lag))
}

# Create lagged variables for 'bot'
for (lag in 1:max_lag) {
  wide_df <- wide_df %>% group_by(file_project) %>% mutate(bot_lag = lag(bot, lag))
}

# Perform the panel OLS regression with fixed effects for file_project
model <- plm(human ~ bot_lag,
             data = wide_df, index = c("file_project"), model = "within")
summary(model)
