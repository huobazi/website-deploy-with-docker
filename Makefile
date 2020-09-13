WORKDIR:=$(shell pwd)
BINDIR:=$(WORKDIR)/bin

.PHONY: usage
usage:
	@echo "Usage: \nThis yfxs deploy controller \nPlease run the inner task"

.PHONY: install-docker
install-docker:
	@sh $(BINDIR)/install-docker.sh

.PHONY: install
install:
	@sh $(BINDIR)/install.sh

.PHONY: update
update:
	@sh $(BINDIR)/update.sh

.PHONY: rollback
rollback:
ifndef YFXS_IMAGE_VERSION
	@echo "Usage: \n	make rollback YFXS_IMAGE_VERSION=20200816225403 \nOR\n	YFXS_IMAGE_VERSION=20200816225403 make rollback"
else
	@make restart-app
	@echo "Rollback to : $(YFXS_IMAGE_VERSION)"
	@echo $(YFXS_IMAGE_VERSION) > .app-evision
endif

.PHONY: secret
secret:
	@test -f ./environments/app.secret.env || echo "SECRET_KEY_BASE=`openssl rand -hex 128`" > $(INCDIR)/environments/app.secret.env
	@cat ./environments/app.secret.env

.PHONY: re-secret
re-secret:
	@rm -f ./environments/app.secret.env && make secret

.PHONY: install-acme
install-acme:
	@sh $(BINDIR)/install-acme.sh

.PHONY: start
start:
	@docker-compose up -d

.PHONY: restart
restart:
	@sh $(BINDIR)/restart.sh

.PHONY: restart-app
restart-app:
	@sh $(BINDIR)/restart-app.sh

.PHONY: status
status:
	@docker-compose ps

.PHONY: stop
stop:
	@docker-compose stop nginx app app_slave worker

.PHONY: stop-all
stop-all:
	@docker-compose down

.PHONY: console
console:
	@docker-compose run app bundle exec rails console

.PHONY: reindex
reindex:
	@echo "Search engine reindex..."
	@docker-compose run app bundle exec rake reindex

.PHONY: backup-db
backup-db:
	@docker-compose exec -u postgres postgres  pg_dump --format=custom --compress=6 --dbname=$(YFXS_POSTGRES_DB) > /backup/$(YFXS_POSTGRES_DB)_$( date +%Y%m%d%H%M%S ).dump

.PHONY: restore-db
restore-db:
ifndef file
	@echo "Usage: \n	make restore-db file=/xx/yy/zz.dump \nOR\n	file=/xx/yy/zz.dump make restore-db"
else
	@docker-compose exec -i -u postgres postgres pg_restore ---dbname=$(YFXS_POSTGRES_DB) $(file)
endif

.PHONY: clean
clean:
	@echo "Clean Docker images..."
	@docker ps -aqf status=exited | xargs docker rm && docker images -qf dangling=true | xargs docker rmi

.PHONY: foo
foo:
	@sh $(BINDIR)/foo.sh