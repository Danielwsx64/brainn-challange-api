APP := challange-api
RUN := docker-compose run $(APP)

setup:
	$(RUN) bundle exec bin/setup

run: setup
	docker-compose up

test: setup
	$(RUN) bundle exec rspec spec

console: setup
	$(RUN) bundle exec rails c

bash:
	$(RUN) /bin/bash
