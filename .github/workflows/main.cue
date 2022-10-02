name: "test-main-on-new-commit"

on: {
	push: branches: [ "main"]
	pull_request: branches: [ "main"]
}

_python_version: string @tag(python_version)

jobs: {
	test: {
		"runs-on": "ubuntu-latest"
		name:      "Test '${{github.ref_name}}'"
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
	deploy: {
		needs:     "test"
		"runs-on": "ubuntu-latest"
		name:      "Deploy '${{github.ref_name}}' to Heroku"
		steps: [
			{
				uses: "actions/checkout@v3"
				with: "fetch-depth": 0
			}, {
				name:  "git push to heroku"
				shell: "bash" // specify this in case GHA ever changes to directly exec'ing if it sees a single-command "run" string
				env: {
					HEROKU_USERNAME:  "${{ secrets.HEROKU_USERNAME }}"
					HEROKU_API_TOKEN: "${{ secrets.HEROKU_API_TOKEN }}"
				}
				run: "git push --repo=https://$HEROKU_USERNAME:$HEROKU_API_TOKEN@git.heroku.com/st1-app-main.git --force"
			},
		]
	}
	regression_test_deployed_main: {
		needs:     "deploy"
		"runs-on": "ubuntu-latest"
		name:      "Regression test '${{github.ref_name}}' on Heroku"
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
				env: BASE_URL: "https://st1-app-main.herokuapp.com"
				run: "make regression"
			},
		]
	}
}
