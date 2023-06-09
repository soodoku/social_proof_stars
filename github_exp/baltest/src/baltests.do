
* -----------------------------------------------------------------------------
* Program Setup
* -----------------------------------------------------------------------------
cls 					// Clear results window
clear all               // Start with a clean slate
set more off            // Disable partitioned output
macro drop _all         // Clear all macros to avoid namespace conflicts
set linesize 120        // Line size limit to make output more readable, affects logs

cap log close
log using ../output/stata-log.txt, replace text

version 13              // Still on version 13 :(

// -----------------------------------------------------------------------------
* Repo baselines
// -----------------------------------------------------------------------------
use "../../get_baseline_profile/output/repo_baselines.dta", clear

gen python_lang = (language == "Python")

local vars_to_encode "language"
foreach var of local vars_to_encode {
    rename `var' `var'_str
    encode `var'_str, gen(`var')
}

global repo_baselines year_created fork size_mb stargazers_count watchers_count has_issues forks open_issues subscribers_count n_topic python_lang

su $global

#delimit;
iebaltab 
	$repo_baselines
	,
	total
	groupvar(treated)
	// ftest
	star(.1 .05 .01)
	stats(pair(nrmd))
	nonote
	grplabels(
		0 Control @
		1 Treated @
		)	
	rowlabels(
		year_created "Year created" @
		fork "Forked = 1" @
		size_mb "Repository size" @
		stargazers_count "Stars" @
		has_issues "Has issues = 1" @
		forks "Number of forks" @
		open_issues "Number of open issues" @
		subscribers_count "Subscribers" @
		n_topics "Number of topics listed" @
		python_lang	"Python = 1"
		)
	savetex(../output/baltest-repo-treated-01.tex) 
	replace
;

#delimit;
iebaltab 
	$repo_baselines
	,
	total
	groupvar(treated2)
	// ftest
	star(.1 .05 .01)
	stats(pair(nrmd))
	nonote
	grplabels(
		0 Control @
		1 Treated (low) @
		2 Treated (high) @
		)	
	rowlabels(
		year_created "Year created" @
		fork "Forked = 1" @
		size_mb "Repository size" @
		stargazers_count "Stars" @
		has_issues "Has issues = 1" @
		forks "Number of forks" @
		open_issues "Number of open issues" @
		subscribers_count "Subscribers" @
		n_topics "Number of topics listed" @
		python_lang	"Python = 1"
		)
	savetex(../output/baltest-repo-treated-012.tex) 
	replace
;
#delimit cr

// -----------------------------------------------------------------------------
* User baselines
// -----------------------------------------------------------------------------
use "../../get_baseline_profile/output/user_baselines.dta", clear

gen org = (type=="Organization")
global user_baselines public_repos public_gists followers following year_created year_updated org list_co list_email list_blog list_bio bio_size
#delimit;
iebaltab 
	$user_baselines
	,
	total
	groupvar(treated)
	// ftest
	star(.1 .05 .01)
	stats(pair(nrmd))
	nonote
		grplabels(
		0 Control @
		1 Treated @
		)	
	rowlabels(
		public_repos "Number of repositories" @ 
		public_gists "Number of gists" @
		followers "Number of followers" @
		following "Number of people followed" @
		year_created "Year created" @
		year_updated "Year updated" @
		org "Organization" @
		list_co "List company" @
		list_email "List email" @
		list_blog "List personal site" @
		list_bio "List brief bio" @
		bio_size "Brief bio length" @
		)
	savetex(../output/baltest-user-treated-01.tex) 
	replace
;

#delimit;
iebaltab 
	$user_baselines
	,
	total
	groupvar(treated2)
	// ftest
	star(.1 .05 .01)
	stats(pair(nrmd))
	nonote
		grplabels(
		0 Control @
		1 Treated (low) @
		2 Treated (high) @
		)	
	rowlabels(
		public_repos "Number of repositories" @ 
		public_gists "Number of gists" @
		followers "Number of followers" @
		following "Number of people followed" @
		year_created "Year created" @
		year_updated "Year updated" @
		org "Organization" @
		list_co "List company" @
		list_email "List email" @
		list_blog "List personal site" @
		list_bio "List brief bio" @
		bio_size "Brief bio length" @
		)
	savetex(../output/baltest-user-treated-012.tex) 
	replace
;
