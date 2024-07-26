set more off
import delimited ../data/pypi_experiment_timeseries.csv, clear

rename date date_str
gen date = date(date_str, "YMD")

rename file_project pkg_str
encode pkg_str, gen(pkg)

* Date when treatment happens
local cutoff_date_str 2023-06-08
gen cutoff_date= date("`cutoff_date_str'", "YMD")
gen t = date - cutoff_date

* End date of sample period
local end_date = date("2023-07-20", "YMD")
local delta_days_obs = `end_date' - cutoff_date

local post_snapshot_date 2023-06-22

// // Remove 100 downloads 3 days after cutoff date
// local cutoff_date_plus_3days = cutoff_date + 3
// 	if (date >= `cutoff_date_plus_3days') & (treatment == 1)

// // Drop treatment window
// drop if (date >= cutoff_date) & (date < `cutoff_date_plus_3days')

eststo clear
// =============================================================
// Medians
// =============================================================
// Post-treat differences snapshot at `post_snapshot_date'
eststo: qreg tt_downloads i.treatment if date==date("`post_snapshot_date'", "YMD"), vce(r) quantile(.5)
	* Add scalars
	// Get mean of y -----------------------------------
	sum `e(depvar)' if e(sample), d
	local ymean: display %9.0fc `r(p50)'
	estadd local ymean "`ymean'"
	// Get obs -----------------------------------------
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "`nobs'"
	// Get packages/N_clusters -------------------------
	estadd local n_packages "23,916"
	// Get days ----------------------------------------
	estadd local n_days 1

// Post-treat differences allowing for dynamics
eststo: qreg2 tt_downloads i.treatment##c.t if date>cutoff_date, cluster(pkg) quantile(.5)
	* Add scalars
	// Get mean of y -----------------------------------
	sum `e(depvar)' if e(sample), d
	local ymean: display %9.0fc `r(p50)'
	estadd local ymean "`ymean'"
	// Get obs -----------------------------------------
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "`nobs'"
	// Get packages/N_clusters -------------------------
	estadd local n_packages "23,916"
	// Get days ----------------------------------------
	estadd local n_days `delta_days_obs'

// =============================================================
// Means
// =============================================================
// Post-treat differences snapshot at `post_snapshot_date'
eststo: reg tt_downloads i.treatment if date==date("`post_snapshot_date'", "YMD"), vce(hc3)
	* Add scalars
	// Get mean of y -----------------------------------
	sum `e(depvar)' if e(sample)
	local ymean: display %9.0fc `r(mean)'
	estadd local ymean "`ymean'"
	// Get obs -----------------------------------------
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "`nobs'"
	// Get packages/N_clusters -------------------------
	estadd local n_packages "`nobs'"
	// Get days ----------------------------------------
	estadd local n_days 1

// Post-treat differences allowing for dynamics
eststo: reg tt_downloads i.treatment##c.t if date>cutoff_date, cluster(pkg)
	* Add scalars
	// Get mean of y -----------------------------------
	sum `e(depvar)' if e(sample)
	local ymean: display %9.0fc `r(mean)'
	estadd local ymean "`ymean'"
	// Get obs -----------------------------------------
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "`nobs'"
	// Get packages/N_clusters -------------------------
	local n_pkg: display %9.0fc `e(N_clust)'
	estadd local n_packages "`n_pkg'"
	// Get days ----------------------------------------
	estadd local n_days `delta_days_obs'



local savepath using ../tabs/pypi_exp_regtable.tex
local fmt %9.1f
#delimit;
esttab `savepath',
	cell(
		b (    fmt(`fmt') star) 
		se(par fmt(`fmt'))
		ci(par(\multicolumn{1}{r}{\text{[$ \:\text{to}\: $]}}) fmt(`fmt'))
		p (par(\multicolumn{1}{r}{\text{$<p= >$}})         fmt(%9.3f)) 
	)
	collabels(, none)
	nonumber
	nomtitle
	noobs
	noomitted
    nobaselevels
	star(+ 0.1 * 0.05 ** 0.01 *** 0.001)
	coeflabels(
		_cons "Constant"
		1.treatment "Treatment group"
		t "Linear trend"
		1.treatment#c.t "Treatment group  $ \times$ Linear trend"
	)
	scalar(
		// "r2 R$^2$"
		"ymean Median/Mean of outcome"
		"n_packages Package observations"
		"n_days Day observations"
		"nobs Package-day observations"
	)
	// Other LaTeX settings
	fragment
	substitute(\_ _)
	booktab
	replace	
;
#delimit cr
