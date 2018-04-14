PIPENV := $(shell command -v pipenv 2> /dev/null)

default: clean install lint tests

# ---- Install ----

install:
ifndef PIPENV
    @pip install pipenv
endif
ifeq ($(CI), "true")
	@pipenv install --dev --skip-lock
else
	@pipenv install -e --dev .
endif

clean: clean-pyc
	@-pipenv --rm

clean-pyc:
	@find ./ -name "*.pyc" -exec rm -rf {} \;

# ---- Tests ----
lint:
	@pipenv run flake8

tests:
	@pipenv run pytest --cov=. tests

# --- Formatting ---

autopep8:
	@pipenv run autopep8 --in-place --recursive .

isort:
	@pipenv run isort -rc -p savage -p tests .

# --- Tools ---

console:
	@pipenv run ipython

pg_shell:
	@docker-compose run --rm postgres /usr/bin/psql -h postgres -U postgres

.PHONY: install clean clean-pyc lint tests autopep8 isort console pg_shell
