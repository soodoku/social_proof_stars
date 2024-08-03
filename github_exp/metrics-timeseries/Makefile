.DEFAULT_GOAL := help

########################################################################
# Symlink
# Link from scripts/get_metrics/output
########################################################################
SYMLINK_OPTS = --symbolic --force --verbose
HARDLINK_OPTS = --force --verbose
.PHONY: link
link: ## Symlink postcode and other maps into input/
	@echo "==> $@"
	@echo "Linking input files.."
	cd input && ln $(HARDLINK_OPTS) ../../sample_and_random_assign/output/random_sample.csv .
	cd input && ln $(HARDLINK_OPTS) ../../get_metrics/output/pkg_pypi_downloads.csv .
	cd input && ln $(HARDLINK_OPTS) ../../get_metrics/output/pkg_human_downloads.csv .
	cd input && ln $(HARDLINK_OPTS) ../../get_metrics/output/repo_stars_timeseries.csv .

.PHONY: purgei
purgei: ## Purge all symlinks in input/
	find input/* -type l -delete

.PHONY: help
help: ## Show this help message and exit
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'