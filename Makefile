SHELL := /bin/bash

################################
# Setup
################################

setup: setup-python install-deps

setup-python:
	brew list python@3.7 || brew install python@3.7
	if [ ! -d venv ]; then\
		python3.7 -m venv venv;\
	fi
	source venv/bin/activate \
	&& pip install pip-tools==6.12.1

################################
# Dependencies
################################

install-deps:
	source venv/bin/activate \
	&& pip-sync dev-requirements.txt

compile-deps:
	pip-compile requirements/local.in -o dev-requirements.txt --no-emit-index-url \

################################
# Deploy
################################

clean-python-build:
	rm -rf dist *.egg-info

_publish-python-package: clean-python-build
	python setup.py sdist \
	&& twine upload dist/*

_publish-python-package-test: clean-python-build
	python setup.py sdist \
	&& twine upload --repository test dist/*

publish-package: _publish-python-package clean-python-build

publish-package-test: _publish-python-package-test clean-python-build


################################
# Linting
################################

black:
	black .

isort:
	isort .

black-check:
	black --check .

isort-check:
	isort --check .

flake:
	flake8

mypy:
	mypy vellum

lint: black isort flake mypy

lint-check: black-check isort-check flake mypy

################################
# Development
################################

test:
	pytest

test-run:
	pytest --no-cov $(filter-out $@,$(MAKECMDGOALS))
