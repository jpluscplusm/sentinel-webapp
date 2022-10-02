package workflow

#Dry: {
	python_version: string @tag(python_version)

	prepare_venv_steps: [
		{
			uses: "actions/checkout@v3"
		}, {
			name: "Install poetry"
			run:  "pipx install poetry"
		}, {
			uses: "actions/setup-python@v4"
			with: {
				"python-version": python_version
				cache:            "poetry"
			}
		}, {
			run: "make dependencies"
		},
	]

}
