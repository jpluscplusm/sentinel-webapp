# Operations notes

GitHub Actions' workflows are stored in `.github/workflows/`.

Each YaML file is generated from its CUE counterpart, via the top-level Makefile target `update_ci_workflows`.

This target validates that each workflow definition adheres to schemastore.org's current idea of what a GitHub Actions workflow looks like, and exports the workflow into the YaML form that GitHub Actions recognises.

.yml files in `.github/workflows/` should not be edited directly.
