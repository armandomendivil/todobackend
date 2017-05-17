# Project variables
PROJECT_NAME ?= toddobackend
ORG_NAME ?= klingan
REPO_NAME ?= todobackend

# Flenames
DEV_COMPOSE_FILE := docker/dev/docker-compose.yml
REL_COMPOSE_FILE := docker/release/docker-compose.yml

REL_PROJECT := $(PROJECT_NAME)$(BUILD_ID)
DEV_PROJECT := $(REL_PROJECT)dev

.PHONY: test build release clean

test:
	${INFO} "Building images..."
	@ docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) build
	${INFO} "Ensuing db is ready..."
	@ docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) up agent
	${INFO} "Running tests..."
	@ docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) up test
	${INFO} "Testing complete"

build:
	${INFO} "Building application artifacts..."
	@ docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) up builder
	${INFO} "Build complete"

release:
	${INFO} "Building images..."
	@ docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) build
	${INFO} "Ensuring database is ready..."
	@ docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) up agent
	${INFO} "Collecting static files..."
	@ docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) run --rm app manage.py collectstatic --noinput
	${INFO} "Running database migrations..."
	@ docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) run --rm app manage.py migrate --noinput
	${INFO} "Running acceptance tests..."
	@ docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) up test
	${INFO} "Accpetance testing complete..."

clean:
	${INFO} "Destroying deployment environment..."
	@ docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) kill
	@ docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) rm -f -v
	@ docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) kill
	@ docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) rm -f -v
	@ docker images -q -f dangling=true -f label=aplication=$(REPO_NAME) | xargs -I ARGS docker rmi -f ARGS
	${INFO} "Clean complete"

YELLOW := "\e[1;33m"
NC := "\e[0m"

INFO := @bash -c '\
	printf $(YELLOW); \
  echo "=> $$1"; \
	printf $(NC)' VALUE
