DEFAULT: help
.PHONY: update-all-workflows help

ALL_WORKFLOWS = main.yml
# As /awful/ as this next line is, it's copied verbatim from the poetry Heroku buildpack compile script at
#   https://github.com/moneymeets/python-poetry-buildpack/blob/master/bin/compile#L85.
# So long as we're using this buildpack, we might as well steal their awfulness
# for deriving the required python version, as we'll be running it during app deployments, anyway.
PYTHON_RUNTIME_VERSION=sed -n -e '/^\[metadata\]/,/^\[/p' poetry.lock | sed -n -e 's/^python-versions\s*=\s*//p' | tr -d \"\'
PYTHON_VERSION = $(shell cd $$(git rev-parse --show-toplevel) && $(PYTHON_RUNTIME_VERSION))

update-all-workflows: $(ALL_WORKFLOWS) ## regenerate all workflow .yml files from .cue sources

%.yml: github-workflow.cue %.cue
	cue vet --concrete \
		--inject "python_version=$(PYTHON_VERSION)" \
		$*.cue \
		github-workflow.cue
	cue export --force \
		--inject "python_version=$(PYTHON_VERSION)" \
		--out yaml \
		--outfile $*.yml \
		$*.cue

.PHONY: github-workflow.json
github-workflow.json: ## download schemastore's github-workflow schema
	wget --timestamping --no-verbose https://json.schemastore.org/github-workflow.json

github-workflow.cue: github-workflow.json ## import upstream JSON schema into CUE
	cue import --force github-workflow.json

help: ## show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
