ENV ?= "dev"
POETRY_GROUPS = "discord,db,dev"

ifeq ($(ENV), prod)
	COMPOSE_YML := compose.prod.yml
else
	COMPOSE_YML := compose.dev.yml
endif

build:
	docker compose -f $(COMPOSE_YML) build

build\:no-cache:
	docker compose -f $(COMPOSE_YML) build --no-cache

up:
	docker compose -f $(COMPOSE_YML) up --build -d

down:
	docker compose -f $(COMPOSE_YML) down

reload:
	docker compose -f $(COMPOSE_YML) build
	docker compose -f $(COMPOSE_YML) down
	docker compose -f $(COMPOSE_YML) up -d

reset:
	docker compose -f $(COMPOSE_YML) down --volumes --remove-orphans --rmi all

logs:
	docker compose -f $(COMPOSE_YML) logs -f

logs\:once:
	docker compose -f $(COMPOSE_YML) logs

ps:
	docker compose -f $(COMPOSE_YML) ps

pr\:create:
	git switch develop
	git push
	gh pr create --base main --head $(shell git branch --show-current)
	gh pr view --web

deploy\:prod:
	make build ENV=prod
	make reload ENV=prod

poetry\:install:
	pip install poetry
	poetry install --with $(group)

poetry\:add:
	poetry add --group=$(group) $(packages)
	make poetry:lock

poetry\:lock:
	poetry lock

poetry\:update:
	poetry update --with $(group)

poetry\:reset:
	poetry env remove $(which python)
	poetry install

dev\:setup:
	poetry install --with $(POETRY_GROUPS)

db\:revision\:create:
	docker compose -f $(COMPOSE_YML) build db-migrator
	docker compose -f $(COMPOSE_YML) run --rm db-migrator /bin/bash -c "alembic revision --autogenerate -m '${NAME}'"

db\:migrate:
	docker compose -f $(COMPOSE_YML) build db-migrator
	docker compose -f $(COMPOSE_YML) run --rm db-migrator /bin/bash -c "alembic upgrade head"

envs\:setup:
	cp envs/discord.env.example envs/discord.env
	cp envs/db.env.example envs/db.env
	cp envs/sentry.env.example envs/sentry.env

PHONY: build up down logs ps pr\:create deploy\:prod poetry\:install poetry\:add poetry\:lock poetry\:update poetry\:reset dev\:setup db\:revision\:create db\:migrate envs\:init