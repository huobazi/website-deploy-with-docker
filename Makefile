WORKDIR:=$(shell pwd)
BINDIR:=$(WORKDIR)/bin

usage:
	@echo "Usage: \nThis yfxs deploy controller \nPlease run the inner task"
install:
	@sh $(BINDIR)/install.sh
update:
	@sh $(BINDIR)/update.sh
rollback:
ifndef YFXS_IMAGE_VERSION
	@echo "Usage: \n	make rollback YFXS_IMAGE_VERSION=20200816225403 \nOR\n	YFXS_IMAGE_VERSION=20200816225403 make rollback"
else
	@make restart-app
	@echo "Rollback to : $(YFXS_IMAGE_VERSION)"
	@echo $(YFXS_IMAGE_VERSION) > .app-evision
endif
secret:
	@test -f ./environments/app.secret.env || echo "SECRET_KEY_BASE=`openssl rand -hex 128`" > $(INCDIR)/environments/app.secret.env
	@cat ./environments/app.secret.env
re-secret:
	@rm -f ./environments/app.secret.env && make secret
start:
	@docker-compose up -d
restart:
	@sh $(BINDIR)/restart.sh
restart-app:
	@sh $(BINDIR)/restart-app.sh
status:
	@docker-compose ps
stop:
	@docker-compose stop nginx app app_slave worker
stop-all:
	@docker-compose down
console:
	@docker-compose run app bundle exec rails console
reindex:
	@echo "Search engine reindex..."
	@docker-compose run app bundle exec rake reindex
backup-db:
	@docker-compose exec -u postgres postgres  pg_dump --format=custom --compress=6 --dbname=$(YFXS_POSTGRES_DB) > /backup/$(YFXS_POSTGRES_DB)_$( date +%Y%m%d%H%M%S ).dump
restore-db:
ifndef file
	@echo "Usage: \n	make restore-db file=/xx/yy/zz.dump \nOR\n	file=/xx/yy/zz.dump make restore-db"
else
	@docker-compose exec -i -u postgres postgres pg_restore ---dbname=$(YFXS_POSTGRES_DB) $(file)
endif
clean:
	@echo "Clean Docker images..."
	@docker ps -aqf status=exited | xargs docker rm && docker images -qf dangling=true | xargs docker rmi
install-docker:
	@sh $(BINDIR)/install-docker.sh
install-acme:
	@sh $(BINDIR)/install-acme.sh
foo:
	@sh $(BINDIR)/foo.sh