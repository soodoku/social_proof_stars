// =============================================================
// PyPI downloads
// =============================================================
cls
import delimited ../input/pkg_pypi_downloads.csv, clear
rename date date_str
gen date = date(date_str, "YMD")

rename pkg pkg_str
encode pkg_str, gen(pkg)

local cutoff_date_str 2023-05-20
gen cutoff_date= date("`cutoff_date_str'", "YMD")
gen t = date - cutoff_date

local end_date = date("2023-10-31", "YMD")
local delta_days_obs = `end_date' - date("`cutoff_date_str'", "YMD") + 1


* Create pre-cutoff date (cutoff_date) mean of downloads
gen pre_treat_period = (date < date("2023-05-12", "YMD"))
bysort pkg: egen pre_treat_mean = mean(cond(pre_treat_period, tt_downloads, .))


// =============================================================
// Means
// =============================================================
eststo clear
* --------------------------------------------------------------
* Snapshot at 20 Jun (1 month relative to 20 May end of treatment period)
local _post_snapshot_date 2023-06-2
eststo: reg tt_downloads i.treated2 pre_treat_mean if date==date("`_post_snapshot_date'", "YMD"), vce(hc3)
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
* Snapshot at 20 July (2 months relative to 20 May end of treatment period)
local _post_snapshot_date 2023-07-20
eststo: reg tt_downloads i.treated2 pre_treat_mean if date==date("`_post_snapshot_date'", "YMD"), vce(hc3)
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
* Snapshot at 20 August (3 months relative to 20 May end of treatment period)
local _post_snapshot_date 2023-08-20
eststo: reg tt_downloads i.treated2 pre_treat_mean if date==date("`_post_snapshot_date'", "YMD"), vce(hc3)
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
* Snapshot at 20 September (4 months relative to 20 May end of treatment period)
local _post_snapshot_date 2023-09-20
eststo: reg tt_downloads i.treated2 pre_treat_mean if date==date("`_post_snapshot_date'", "YMD"), vce(hc3)
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
* Snapshot at 20 October (5 months relative to 20 May end of treatment period)
local _post_snapshot_date 2023-10-20
eststo: reg tt_downloads i.treated2 pre_treat_mean if date==date("`_post_snapshot_date'", "YMD"), vce(hc3)
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
eststo: reg tt_downloads i.treated2##c.t pre_treat_mean if date>=cutoff_date, cluster(pkg)
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

local savepath using ../output/github_exp_regtable.tex
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
		1.treated2 "Treatment (low dosage)"
		2.treated2 "Treatment (high dosage)"
		t "Linear trend"
		1.treated2#c.t "Treatment (low dosage)  $ \times$ Linear trend"
		2.treated2#c.t "Treatment (high dosage) $ \times$ Linear trend"
		pre_treat_mean "Pre-treatment mean of downloads"
	)
	order(
		1.treated2
		2.treated2
		t
		1.treated2#c.t
		2.treated2#c.t
		pre_treat_mean
	)
	scalar(
		"r2 R$^2$"
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



// =============================================================
// Medians
// =============================================================
eststo clear
* --------------------------------------------------------------
* Snapshot at 20 Jun (1 month relative to 20 May end of treatment period)
local _post_snapshot_date 2023-06-20
eststo: qreg tt_downloads i.treated2 pre_treat_mean if date==date("`_post_snapshot_date'", "YMD"), vce(r) quantile(.5)
	* Add scalars
	// Get median of y -----------------------------------
	sum `e(depvar)' if e(sample), d
	local ymedian: display %9.1fc `r(p50)'
	estadd local ymedian "`ymedian'"
	// Get obs -----------------------------------------
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "`nobs'"
	// Get packages/N_clusters -------------------------
	estadd local n_packages "`nobs'"
	// Get days ----------------------------------------
	estadd local n_days 1

* --------------------------------------------------------------
* Snapshot at 20 July (2 months relative to 20 May end of treatment period)
local _post_snapshot_date 2023-07-20
eststo: qreg tt_downloads i.treated2 pre_treat_mean if date==date("`_post_snapshot_date'", "YMD"), vce(r) quantile(.5)
	* Add scalars
	// Get median of y -----------------------------------
	sum `e(depvar)' if e(sample), d
	local ymedian: display %9.1fc `r(p50)'
	estadd local ymedian "`ymedian'"
	// Get obs -----------------------------------------
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "`nobs'"
	// Get packages/N_clusters -------------------------
	estadd local n_packages "`nobs'"
	// Get days ----------------------------------------
	estadd local n_days 1


* --------------------------------------------------------------
* Snapshot at 20 August (3 months relative to 20 May end of treatment period)
local _post_snapshot_date 2023-08-20
eststo: qreg tt_downloads i.treated2 pre_treat_mean if date==date("`_post_snapshot_date'", "YMD"), vce(r) quantile(.5)
	* Add scalars
	// Get median of y -----------------------------------
	sum `e(depvar)' if e(sample), d
	local ymedian: display %9.1fc `r(p50)'
	estadd local ymedian "`ymedian'"
	// Get obs -----------------------------------------
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "`nobs'"
	// Get packages/N_clusters -------------------------
	estadd local n_packages "`nobs'"
	// Get days ----------------------------------------
	estadd local n_days 1

* --------------------------------------------------------------
* Snapshot at 20 September (4 months relative to 20 May end of treatment period)
local _post_snapshot_date 2023-09-20
eststo: qreg tt_downloads i.treated2 pre_treat_mean if date==date("`_post_snapshot_date'", "YMD"), vce(r) quantile(.5)
	* Add scalars
	// Get median of y -----------------------------------
	sum `e(depvar)' if e(sample), d
	local ymedian: display %9.1fc `r(p50)'
	estadd local ymedian "`ymedian'"
	// Get obs -----------------------------------------
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "`nobs'"
	// Get packages/N_clusters -------------------------
	estadd local n_packages "`nobs'"
	// Get days ----------------------------------------
	estadd local n_days 1

* --------------------------------------------------------------
* Snapshot at 20 October (5 months relative to 20 May end of treatment period)
local _post_snapshot_date 2023-09-20
eststo: qreg tt_downloads i.treated2 pre_treat_mean if date==date("`_post_snapshot_date'", "YMD"), vce(r) quantile(.5)
	* Add scalars
	// Get median of y -----------------------------------
	sum `e(depvar)' if e(sample), d
	local ymedian: display %9.1fc `r(p50)'
	estadd local ymedian "`ymedian'"
	// Get obs -----------------------------------------
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "`nobs'"
	// Get packages/N_clusters -------------------------
	estadd local n_packages "`nobs'"
	// Get days ----------------------------------------
	estadd local n_days 1


* --------------------------------------------------------------
* Post-treat differences allowing for dynamics
eststo: qreg2 tt_downloads i.treated2##c.t pre_treat_mean if date>=cutoff_date, cluster(pkg) quantile(.5)
	* Add scalars
	// Get median of y -----------------------------------
	sum `e(depvar)' if e(sample), d
	local ymedian: display %9.1fc `r(p50)'
	estadd local ymedian "`ymedian'"
	// Get obs -----------------------------------------
	local nobs: display %9.0fc `e(N)'
	estadd local nobs "`nobs'"
	// Get packages/N_clusters -------------------------
	qui tabulate pkg if e(sample)
	estadd local n_packages `r(r)'
	// Get days ----------------------------------------
	estadd local n_days `delta_days_obs'

local savepath using ../output/github_exp_medians_regtable.tex
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
		1.treated2 "Treatment (low dosage)"
		2.treated2 "Treatment (high dosage)"
		t "Linear trend"
		1.treated2#c.t "Treatment (low dosage)  $ \times$ Linear trend"
		2.treated2#c.t "Treatment (high dosage) $ \times$ Linear trend"
		pre_treat_mean "Pre-treatment mean of downloads"
	)
	order(
		1.treated2
		2.treated2
		t
		1.treated2#c.t
		2.treated2#c.t
		pre_treat_mean
	)
	scalar(
		"ymedian Median of outcome"
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


