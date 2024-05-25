// =============================================================
// PyPI downloads
// =============================================================
import delimited ../input/pkg_pypi_downloads.csv, clear
rename date date_str
gen date = date(date_str, "YMD")

rename pkg pkg_str
encode pkg_str, gen(pkg)

local cutoff_date_str 2023-05-19
gen cutoff_date= date("`cutoff_date_str'", "YMD")
gen t = date - cutoff_date

local end_date = date("2023-06-10", "YMD")
local delta_days_obs = `end_date' - date("`cutoff_date_str'", "YMD") + 1

local post_snapshot_date 2023-06-02

eststo clear
// Post-treat differences snapshot at `post_snapshot_date'
eststo: reg tt_downloads i.treated2 if date==date("`post_snapshot_date'", "YMD"), cluster(pkg)
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
	estadd local n_days 1

// Post-treat differences allowing for dynamics
eststo: reg tt_downloads i.treated2##c.t if date>=date("`cutoff_date_str'", "YMD"), cluster(pkg)
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

local savepath using ../output/github_exp_did_regtable.tex
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
	)
	scalar(
		// "r2 R$^2$"
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
// GitHub stars
// =============================================================
import delimited ../input/repo_stars_timeseries.csv, clear
rename date date_str
gen date = date(date_str, "YMD")

rename fileslug pkg_str
encode pkg_str, gen(pkg)

local cutoff_date_str 2023-05-19
gen cutoff_date= date("`cutoff_date_str'", "YMD")
gen t = date - cutoff_date

local end_date = date("2023-06-10", "YMD")
local delta_days_obs = `end_date' - date("`cutoff_date_str'", "YMD") + 1

local post_snapshot_date 2023-06-02

eststo clear
// Post-treat differences snapshot at `post_snapshot_date'
eststo: reg stars i.treated2 if date==date("`post_snapshot_date'", "YMD"), cluster(pkg)
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
	estadd local n_days 1

// Post-treat differences allowing for dynamics
eststo: reg stars i.treated2##c.t if date>=date("`cutoff_date_str'", "YMD"), cluster(pkg)
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

local savepath using ../output/github_exp_did_stars_regtable.tex
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
	)
	scalar(
		// "r2 R$^2$"
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
