package workflow

name: "Regression test the Production deployment"

on: {
	schedule: [ {
		cron: "19 9-17 * * *" // 19 minutes past the hour, between 9am and 5 pm
	}]
}

jobs: {
	regression_test_production: {
		"runs-on": "ubuntu-latest"
		name:      "Regression test Production deployment"
		steps:     #Dry.prepare_venv_steps + [
				{
				env: BASE_URL: "https://st1-app-production.herokuapp.com"
				run: "make regression"
			},
		]
	}
}
