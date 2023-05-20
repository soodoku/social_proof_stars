.DEFAULT_GOAL := help

########################################################################\
Make gitignore file
########################################################################
.PHONY: giti
giti: ## Make .gitignore from gitignore.io
	@echo "==> $@"
	rm -rf .gitignore
	echo "venv*" > .gitignore
	echo "Copy*.ipynb" >> .gitignore
	echo "scratch/*" >> .gitignore
	echo "*xlsx" >> .gitignore
	echo "**/*.tar.gz" >> .gitignore
	echo "**/*.csv*" >> .gitignore
	echo "**/*.xls" >> .gitignore
	echo "**/*.xlsx" >> .gitignore
	curl https://www.toptal.com/developers/gitignore/api/python >> .gitignore
	curl https://www.toptal.com/developers/gitignore/api/jupyternotebooks >> .gitignore
	curl https://www.toptal.com/developers/gitignore/api/tex >> .gitignore

# ============================================================================
# Set up the Python virtual environment and prepare the Jupyter distribution
# Installs packages from requirements.txt
# ============================================================================
.PHONY: setup
VENVPATH ?= venv
ifeq ($(OS),Windows_NT)
	VENVPATH :=  c:/users/admin/$(VENVPATH)
	ACTIVATE_PATH := $(VENVPATH)/Scripts/activate
else
	ACTIVATE_PATH := $(VENVPATH)/bin/activate
endif
setup: ## Set up venv	
setup: requirements.txt
	@echo "==> $@"
	@echo "==> Creating and initializing virtual environment..."
	rm -rf $(VENVPATH)
	python -m venv $(VENVPATH)
	. $(ACTIVATE_PATH) && \
		pip install --upgrade pip && \
		which pip && \
		pip list && \
		echo "==> Installing requirements" && \
		pip install -r $< && \
		jupyter contrib nbextensions install --sys-prefix --skip-running-check && \
		echo "==> Packages available:" && \
		which pip && \
		pip list && \
		which jupyter && \
		deactivate
	@echo "==> Setup complete."

# ============================================================================
# Open Jupyter notebook in the venv
# ============================================================================
.PHONY: jn
jn: ## Launch jupyter notebook in venv
	@echo "==> $@"
	if [ -f $(VENVPATH)/Scripts/activate ]; then \
		. $(VENVPATH)/Scripts/activate && jupyter notebook; \
	elif [ -f $(VENVPATH)/bin/activate ]; then \
		. $(VENVPATH)/bin/activate && jupyter notebook; \
	else \
		@echo "No venv found"; \
	fi

########################################################################\
Show symlinks
########################################################################
SYMLINKS_CMD := find . -type l -exec sh -c 'printf "%s -> %s\n" "$$0" "$$(readlink -f "$$0")"' {} \;
.PHONY: slr
rsl: ## Report the symbolic links (recursive) 
	@echo "==> $@"
	@echo "Symbolic links:"
	@echo "==============="
	@$(SYMLINKS_CMD)

########################################################################\
Build symlinks graphs as tasks
########################################################################
.PHONY: linktasks
linktasks: ## Link tasks & get task dependency graphs
	@echo "==> $@"
	symlink-tasks
	dot -Tpng -o tasks.png SymlinksTasks.dot -Grankdir=LR

.PHONY: purgelinktasks
purgelinktasks: ## Remove all .dot and .png files
	rm -f *.dot *.png	


########################################################################\
Build symlinks graphs as tasks
########################################################################
.PHONY: sl
SYMLINKS := symlinks.dot
sl: ## Make graph of symlinks
sl: clean_sl $(SYMLINKS)

$(SYMLINKS):
	@echo "==> $@"
	@echo "Making graphviz dot file of symlinks"
	@$(eval SYMLINKS := $(shell find . -type l))
	@echo "digraph $(basename $@) {" > $@
	@for link in $(SYMLINKS); do \
		source=$$(echo $$link | sed -e 's|^\./||'); \
		target=$$(readlink $$link | sed -e 's|^\./||'); \
		echo "\"$$source\" -> \"$$target\";">> $@; \
	done
	@echo "}" >> $@
	@echo "Symlinks:"
	@echo "========="
	@cat $@
	@dot -Tpng $@ -o $(basename $@).png


.PHONY: clean_sl
clean_sl: ## Clean symlinks reports
	@echo "==> $@"
	rm -rf $(SYMLINKS) $(basename $(SYMLINKS)).png

########################################################################
# Other utilities
########################################################################
.PHONY: clean
clean: ## Clean all symlinks aux reports
clean: clean_sl clean_sl_task

.PHONY: help
help: ## Show this help message and exit
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'