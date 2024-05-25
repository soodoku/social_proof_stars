import delimited ../data/pypi_experiment_timeseries.csv, clear

rename timestamp_date date_str
gen date = date(date_str, "YMD")

rename file_project pkg_str
encode pkg_str, gen(pkg)

local cutoff_date_str 2023-06-05
gen cutoff_date= date("`cutoff_date_str'", "YMD")
gen t = date - cutoff_date

* End date of sample period
local end_date = date("2023-07-19", "YMD")
local delta_days_obs = `end_date' - date("`cutoff_date_str'", "YMD") + 1

local post_snapshot_date 2023-06-18

eststo clear
// Post-treat differences snapshot at `post_snapshot_date'
eststo: reg cumulative_downloads i.treatment if date==date("`post_snapshot_date'", "YMD"), cluster(pkg)
	* Add scalars
	// Get mean of y -----------------------------------
	sum `e(depvar)' if e(sample)
	local ymean: display %9.0fc `r(mean)'
	estadd local ymean "`ymean'"
	// Get obs -----------------------------------------
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "`nobs'"
	// Get packages/N_clusters -------------------------
	estadd local n_packages `e(N_clust)'
	// Get days ----------------------------------------
	estadd local n_days 1

// Post-treat differences allowing for dynamics
eststo: reg cumulative_downloads i.treatment##c.t if date>=date("`cutoff_date_str'", "YMD"), cluster(pkg)
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

// Post-treat differences snapshot at `post_snapshot_date'
eststo: qreg2 cumulative_downloads i.treatment if date==date("`post_snapshot_date'", "YMD"), cluster(pkg) quantile(.5)

	* Add scalars
	// Get mean of y -----------------------------------
	sum `e(depvar)' if e(sample), d
	local ymean: display %9.0fc `r(p50)'
	estadd local ymean "`ymean'"
	// Get obs -----------------------------------------
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "`nobs'"
	// Get packages/N_clusters -------------------------
	estadd local n_packages `e(N_clust)'
	// Get days ----------------------------------------
	estadd local n_days 1

// Post-treat differences allowing for dynamics
eststo: qreg2 cumulative_downloads i.treatment##c.t if date>=date("`cutoff_date_str'", "YMD"), cluster(pkg) quantile(.5)
	* Add scalars
	// Get mean of y -----------------------------------
	sum `e(depvar)' if e(sample), d
	local ymean: display %9.0fc `r(p50)'
	estadd local ymean "`ymean'"
	// Get obs -----------------------------------------
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "`nobs'"
	// Get packages/N_clusters -------------------------
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
		"ymean Mean/Median of outcome"
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
