DEFAULT: help
.PHONY: dependencies server unit coverage regression integration help

POETRY ?= poetry run

# `sniffio`'s installation tickes the "keyring" backend auth process.
# this next envvar stops this from accessing your actual /system/ keyring (or failing, if denied access)
dependencies: PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring
dependencies: ## Install the project's dependencies using poetry
	poetry install

server: ## run a hot-reload sentinel server on port $PORT
	$(POETRY) uvicorn sentinel.api:app --host 0.0.0.0 --port $(PORT) --reload

unit: ## run the unit tests
	$(POETRY) pytest tests/test_unit.py

coverage: ## run the unit tests, writing test coverage out to .coverage, and assert that test coverage is >= 90%
	$(POETRY) coverage run -m pytest tests/test_unit.py
	$(POETRY) coverage report --fail-under 90

regression: BASE_URL ?= http://localhost:8000
regression: ## run the regression tests against a running server
	$(POETRY) pytest tests/test_regression.py

integration: ## run the integration tests
	$(POETRY) pytest tests/test_integration.py

help: ## show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
