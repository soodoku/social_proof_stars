.DEFAULT_GOAL := help

########################################################################
# Symlink
# Link from scripts/get_metrics/output
########################################################################
SYMLINK_OPTS = --symbolic --force --verbose
.PHONY: link
link: ## Symlink postcode and other maps into input/
	@echo "==> $@"
	@echo "Linking input files.."
	cd input && ln $(SYMLINK_OPTS) ../../sample_and_random_assign/output/check-github-url.csv .
	cd input && ln $(SYMLINK_OPTS) ../../sample_and_random_assign/output/random_sample.csv .

.PHONY: purgei
purgei: ## Purge all symlinks in input/
	find input/* -type l -delete

.PHONY: help
help: ## Show this help message and exit
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'