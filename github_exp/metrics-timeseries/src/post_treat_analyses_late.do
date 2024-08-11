set more off
// =============================================================
// PyPI downloads
// =============================================================
cls
import delimited ../input/pkg_human_downloads.csv, clear
rename date date_str
gen date = date(date_str, "YMD")

rename pkg pkg_str
encode pkg_str, gen(pkg)

local cutoff_date_str 2023-05-20
gen cutoff_date= date("`cutoff_date_str'", "YMD")
gen t = date - cutoff_date

local end_date = date("2023-10-31", "YMD")
local delta_days_obs = `end_date' - date("`cutoff_date_str'", "YMD") + 1


// =============================================================
// Means
// =============================================================
eststo clear
* --------------------------------------------------------------
* Snapshot at 21 Jun (1 month relative to 21 May end of treatment period)
local _post_snapshot_date 2023-06-21
eststo: ivreg2 tt_downloads (i.treated=i.treatment) if date==date("`_post_snapshot_date'", "YMD"), r first
	* Add scalars
	// Get mean of y -----------------------------------
	sum `e(depvar)' if e(sample)
	local ymean: display %9.1fc `r(mean)'
	estadd local ymean "`ymean'"
	// Get obs -----------------------------------------
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "`nobs'"
	// Get packages/N_clusters -------------------------
	estadd local n_packages "`nobs'"
	// Get days ----------------------------------------
	estadd local n_days 1

* --------------------------------------------------------------
* Snapshot at 21 July (2 months relative to 21 May end of treatment period)
local _post_snapshot_date 2023-07-21
eststo: ivreg2 tt_downloads (i.treated=i.treatment) if date==date("`_post_snapshot_date'", "YMD"), r first
	// Get mean of y -----------------------------------
	sum `e(depvar)' if e(sample)
	local ymean: display %9.1fc `r(mean)'
	estadd local ymean "`ymean'"
	// Get obs -----------------------------------------
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "`nobs'"
	// Get packages/N_clusters -------------------------
	estadd local n_packages "`nobs'"
	// Get days ----------------------------------------
	estadd local n_days 1


* --------------------------------------------------------------
* Snapshot at 21 August (3 months relative to 21 May end of treatment period)
local _post_snapshot_date 2023-08-21
eststo: ivreg2 tt_downloads (i.treated=i.treatment) if date==date("`_post_snapshot_date'", "YMD"), r first
	// Get mean of y -----------------------------------
	sum `e(depvar)' if e(sample)
	local ymean: display %9.1fc `r(mean)'
	estadd local ymean "`ymean'"
	// Get obs -----------------------------------------
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "`nobs'"
	// Get packages/N_clusters -------------------------
	estadd local n_packages "`nobs'"
	// Get days ----------------------------------------
	estadd local n_days 1

* --------------------------------------------------------------
* Snapshot at 21 September (4 months relative to 21 May end of treatment period)
local _post_snapshot_date 2023-09-21
eststo: ivreg2 tt_downloads (i.treated=i.treatment) if date==date("`_post_snapshot_date'", "YMD"), r first
	* Add scalars
	// Get mean of y -----------------------------------
	sum `e(depvar)' if e(sample)
	local ymean: display %9.1fc `r(mean)'
	estadd local ymean "`ymean'"
	// Get obs -----------------------------------------
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "`nobs'"
	// Get packages/N_clusters -------------------------
	estadd local n_packages "`nobs'"
	// Get days ----------------------------------------
	estadd local n_days 1

* --------------------------------------------------------------
* Snapshot at 21 October (5 months relative to 21 May end of treatment period)
local _post_snapshot_date 2023-10-21
eststo: ivreg2 tt_downloads (i.treated=i.treatment) if date==date("`_post_snapshot_date'", "YMD"), r first
	* Add scalars
	// Get mean of y -----------------------------------
	sum `e(depvar)' if e(sample)
	local ymean: display %9.1fc `r(mean)'
	estadd local ymean "`ymean'"
	// Get obs -----------------------------------------
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "`nobs'"
	// Get packages/N_clusters -------------------------
	estadd local n_packages "`nobs'"
	// Get days ----------------------------------------
	estadd local n_days 1

* --------------------------------------------------------------
* Post-treat differences allowing for dynamics
eststo: ivreg2 tt_downloads t (i.treated i.treated#c.t = i.treatment i.treatment#c.t) if date>=cutoff_date, cluster(pkg) first
	* Add scalars
	// Get mean of y -----------------------------------
	sum `e(depvar)' if e(sample)
	local ymean: display %9.1fc `r(mean)'
	estadd local ymean "`ymean'"
	// Get obs -----------------------------------------
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "`nobs'"
	// Get packages/N_clusters -------------------------
	estadd local n_packages `e(N_clust)'
	// Get days ----------------------------------------
	estadd local n_days `delta_days_obs'


#delimit;
esttab,
	varwidth(40)
	se
	collabels(, none)
	noomitted
    nobaselevels
	star(+ 0.1 * 0.05 ** 0.01 *** 0.001)
	coeflabels(
		_cons "Constant"
		1.treated "Received treatment"
		t "Linear trend"
		1.treated#c.t "Received treatment  $ \times$ Linear trend"
	)
	order(
		1.treated
		t
		1.treated#c.t
	)
	scalar(
		// "r2 R$^2$"
		"ymean Median/Mean of outcome"
		"n_packages Package observations"
		"n_days Day observations"
		"nobs Package-day observations"
	)
	// Other LaTeX settings
;
#delimit cr

local savepath using ../output/github_exp_regtable_allhumaninstallers_late.tex
local fmt %9.1fc
#delimit;
esttab `savepath',
	cell(
		b (    fmt(`fmt') star) 
		se(par fmt(`fmt'))
		ci(par(\multicolumn{1}{c}{\text{[$ \:\text{to}\: $]}}) fmt(`fmt'))
		p (par(\multicolumn{1}{c}{\text{$<p= >$}})         fmt(%9.3f)) 
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
		1.treated "Received treatment"
		t "Linear trend"
		1.treated#c.t "Received treatment  $ \times$ Linear trend"
	)
	order(
		1.treated
		t
		1.treated#c.t
	)
	scalar(
		"ymean Mean of outcome"
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
