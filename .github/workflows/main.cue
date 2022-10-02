name: "test-main-on-new-commit"

on: {
	push: branches: [ "main"]
	pull_request: branches: [ "main"]
}

_python_version: string @tag(python_version)

jobs: {
	test: {
		"runs-on": "ubuntu-latest"
		name:      "Unit & integration test branch '${{github.ref_name}}'"
		steps: [
			{
				uses: "actions/checkout@v3"
			}, {
				name: "Install poetry"
				run:  "pipx install poetry"
			}, {
				uses: "actions/setup-python@v4"
				with: {
					"python-version": _python_version
					cache:            "poetry"
				}
			}, {
				run: "make dependencies"
			}, {
				run: "make unit"
			}, {
				run: "make integration"
			},
		]
	}
}
