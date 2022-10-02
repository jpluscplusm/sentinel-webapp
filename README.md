# Sentinel

Sentinel is an application written in Python that may be used to perform sentiment analysis on a piece of text. It leverages an external API for this purpose and provides a safe default when the API is unavailable.

## Commands

The following commands describe how the application may be built, run and tested. Note that [Python 3.10](https://docs.python.org/3/whatsnew/3.10.html) and [Poetry](https://python-poetry.org/) are required.  See [SETUP.md](SETUP.md) for OS-specific setup steps for these dependencies.

Commands following "make" are specified inside the `Makefile`. Run `make help` for a list of commands you can run.

### Setup

```sh
make dependencies
```

### Run

#### Run entirely locally

```sh
make server
```

#### Run locally, but as if we were running inside Heroku

```sh
make heroku
```

From another terminal window, you may query the application with:

```sh
curl -XPOST http://localhost:8000/analyze -H "Content-Type: application/json" -d '{"text": "This is a test."}'
```

### Unit tests and coverage

#### Tests by themselves

```sh
make unit
```

#### Tests with the (local) coverage report being updated

```sh
make coverage
```

### Regression tests

By default, regression tests run against an application running on `localhost:8000`. However, you may use the `BASE_URL` environment variable to run against a different URL.

```sh
make regression
```

### Integration tests

```sh
make integration
```
