name: "test-main-on-new-commit"

on: {
	push: branches: [ "main"]
	pull_request: branches: [ "main"]
}

jobs: {
	test: {
		"runs-on": "ubuntu-latest"
		steps: [
			{
				uses: "actions/checkout@v3"
			}, {
				name: "Install poetry"
				run:  "pipx install poetry"
			}, {
				uses: "actions/setup-python@v4"
				with: {
					"python-version": 3.10
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
