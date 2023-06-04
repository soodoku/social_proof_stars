# Notes

### `pypi-package-index.ipynb`

* Indexes the universe (snapshot) of PyPI packages (from [https://pypi.org/simple/](https://pypi.org/simple/)
* Meant to be run more than once (different snapshots)
* Only contains extant packages (deleted packages not in snapshot)
* Output: `pypi-packages<date>.json` (e.g., `pypi-packages2023-04-24.json`)

### `pypi-specific-pkg.ipynb`

* Just to see what info is available from PyPI for a specific package

### `new-pkg-30April-24April.ipynb`

* Finds new packages between 24 April to 30 April
* By taking diff in snapshot between those two dates
* Output: `new-pkg-30April-24April.csv`


### `check-github-url.ipynb`

* Checks for GitHub repo URL correctness and existence
* Output: `check-github-url.csv`

### `get-packages.ipynb`

* Scan PyPI packages for "new" packages
* "new" packages defined by `cutoff_date` in the notebook
* 
### `pypinfo.ipynb`

* Just to see if `pypinfo` can get what we need 

### `startrack.ipynb`

* Just to see what API endpoint for each star and its timestamp
* Can give timeseries of stars for a repo

### `manual_check.ipynb` 

* Randomly sample 100 new packages (24 April to 30 April)
* And manually check through each to see if there is a readme and if they really are new packages
* Main output: `passed.csv`
