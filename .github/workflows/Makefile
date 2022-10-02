DEFAULT: help
.PHONY: update-all-workflows help

ALL_WORKFLOWS = main.yml production.yml
# As /awful/ as this next line is, it's copied verbatim from the poetry Heroku buildpack compile script at
#   https://github.com/moneymeets/python-poetry-buildpack/blob/master/bin/compile#L85.
# So long as we're using this buildpack, we might as well steal their awfulness
# for deriving the required python version, as we'll be running it during app deployments, anyway.
PYTHON_RUNTIME_VERSION=sed -n -e '/^\[metadata\]/,/^\[/p' poetry.lock | sed -n -e 's/^python-versions\s*=\s*//p' | tr -d \"\'
PYTHON_VERSION = $(shell cd $$(git rev-parse --show-toplevel) && $(PYTHON_RUNTIME_VERSION))

update-all-workflows: $(ALL_WORKFLOWS) ## regenerate all workflow .yml files from .cue sources

%.yml: spec/github-workflow.cue %.cue
	cue vet --concrete \
		--inject "python_version=$(PYTHON_VERSION)" \
		spec/github-workflow.cue dry.cue \
		$*.cue
	cue export --force \
		--inject "python_version=$(PYTHON_VERSION)" \
		--out yaml \
		--outfile $*.yml \
		dry.cue \
		$*.cue

.PHONY: spec/github-workflow.json
spec/github-workflow.json: ## download schemastore's github-workflow schema
	wget --no-clobber --directory-prefix=spec https://json.schemastore.org/github-workflow.json

# We deliberately don't declare a dependency on the schema JSON from the CUE.
# This is so the .json can be PHONY, but the happy-path of workflow .yml
# creation from .cue doesn't need to involve a network trip for the
# usually-unchanged .json. Make! ¯\_(ツ)_/¯
spec/github-workflow.cue: ## import upstream JSON schema into CUE
	cue import --force spec/github-workflow.json --outfile spec/github-workflow.cue

help: ## show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
