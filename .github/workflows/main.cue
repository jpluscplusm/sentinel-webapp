package workflow

name: "Test, deploy, and promote main on each push"

on: {
	push: branches: [ "main"]
	pull_request: branches: [ "main"]
}

jobs: {
	test: {
		"runs-on": "ubuntu-latest"
		name:      "Test '${{github.ref_name}}'"
		steps:     #Dry.prepare_venv_steps + // look in `dry.cue` for the #Dry namespace ...
			[
				{run: "make unit"},
				{run: "make coverage"},
				{run: "make integration"},
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
	regression_test_main: {
		needs:     "deploy"
		"runs-on": "ubuntu-latest"
		name:      "Regression test '${{github.ref_name}}' deployment"
		steps:     #Dry.prepare_venv_steps + [
				{
				env: BASE_URL: "https://st1-app-main.herokuapp.com"
				run: "make regression"
			},
		]
	}
	promote_to_staging: {
		needs:     "regression_test_main"
		"runs-on": "ubuntu-latest"
		name:      "Promote '${{github.ref_name}}' to Staging"
		steps: [
			{
				uses: "actions/checkout@v3"
			}, {
				name: "Put Heroku username in ~/.netrc"
				env: HEROKU_USERNAME: "${{ secrets.HEROKU_USERNAME }}"
				run: #"printf "machine api.heroku.com login %s" "$HEROKU_USERNAME" >> $HOME/.netrc"#
			}, {
				env: HEROKU_API_KEY: "${{ secrets.HEROKU_API_TOKEN }}"
				run: "heroku pipelines:promote -a st1-app-main"
			},
		]
	}
	regression_test_staging: {
		needs:     "promote_to_staging"
		"runs-on": "ubuntu-latest"
		name:      "Regression test Staging deployment"
		steps:     #Dry.prepare_venv_steps + [
				{
				env: BASE_URL: "https://st1-app-staging.herokuapp.com"
				run: "make regression"
			},
		]
	}
}
