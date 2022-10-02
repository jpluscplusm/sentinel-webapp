DEFAULT: help
.PHONY: dependencies server unit coverage regression integration help

POETRY ?= poetry run
PORT   ?= 8000

# `sniffio`'s installation tickes the "keyring" backend auth process.
# this next envvar stops this from accessing your actual /system/ keyring (or failing, if denied access)
dependencies: PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring
dependencies: ## Install the project's python dependencies using poetry
	poetry install

server: ## run a hot-reload sentinel server on port $PORT
	$(POETRY) uvicorn sentinel.api:app --host 0.0.0.0 --port $(PORT) --reload

heroku: ## run a local as-if-we-were-inside-heroku server
	$(POETRY) heroku local --port $(PORT)

unit: ## run the unit tests
	$(POETRY) pytest tests/test_unit.py

coverage: ## run the unit tests, writing test coverage out to .coverage, and assert that test coverage is >= 90%
	$(POETRY) coverage run -m pytest tests/test_unit.py
	$(POETRY) coverage report --fail-under 90

regression: export BASE_URL ?= http://localhost:$(PORT)
regression: ## run the regression tests against a running server
	$(POETRY) pytest tests/test_regression.py

integration: ## run the integration tests
	$(POETRY) pytest tests/test_integration.py

update_ci_workflows: ## validate and update CI workflow definitions
	$(MAKE) -C .github/workflows update-all-workflows

help: ## show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
