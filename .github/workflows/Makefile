DEFAULT: help
.PHONY: update-all-workflows help

ALL_WORKFLOWS = main.yml

update-all-workflows: $(ALL_WORKFLOWS) ## regenerate all workflow .yml files from .cue sources

%.yml: github-workflow.cue %.cue
	cue vet --concrete \
		$*.cue \
		github-workflow.cue
	cue export --force \
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
