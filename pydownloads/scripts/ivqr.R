library(here)
library(IVQR)
library(readr)
library(dplyr)

pypi <- read_csv(here("pydownloads/data/pypi_experiment_timeseries.csv"))

pypi_small <- pypi %>%
  filter(date == "2023-06-22")

median(pypi_small$tt_downloads[pypi_small$treated == 1])
median(pypi_small$tt_downloads[pypi_small$treated == 0 & pypi_small$treatment == 1])
median(pypi_small$tt_downloads[pypi_small$treatment == 0])

# pre-treatment series for treated = 1, treated = 0 and treatment = 1, treatment = 0

model <- tt_downloads ~ treated | treatment | 1
taus  <- c(0.25,0.5,0.75)
median_model <- ivqr(formula = model, 
                     taus = taus, 
                     data = pypi_small, 
                     grid = seq(-100, 1000, 100000))

# each row is a package
# average (day 25--35)
# day 30


