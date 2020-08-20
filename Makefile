POSTGRES_DB=yfxs_production
IMAGE_NAME:=registry-internal.cn-hangzhou.aliyuncs.com/huobazi/yfxs

install:
	@make secret
	@docker-compose run app bundle exec rake db:prepare
	@sh ./bin/touch-deploy-tag.sh
	@make install-acme
update:	
	@docker-compose pull
	@make secret
	@make restart
	@sh ./bin/touch-deploy-tag.sh
rollback:
ifndef IMAGE_VERSION
	@echo "Usage: \n make rollback IMAGE_VERSION=20200816225403 \n OR\n  IMAGE_VERSION=20200816225403 make rollback"
else
	@make restart-app
	@echo "Rollback to : $(IMAGE_VERSION)"
	@echo $(version) > .app-evision
endif
secret:
	@test -f ./environments/app.secret.env || echo "SECRET_KEY_BASE=`openssl rand -hex 128`" > ./environments/app.secret.env
	@cat ./environments/app.secret.env
re-secret:
	@rm -f ./environments/app.secret.env && make secret
start:
	@docker-compose up -d
restart:
	@make restart-app
	@docker-compose stop nginx
	@docker-compose up -d app
	@docker-compose stop app_backup
restart-app:
	@docker-compose up -d app_slave
	@sleep 15
	@docker-compose stop app
	@docker-compose up -d app
	@sleep 20
	@docker-compose stop app_slave worker
	@docker-compose up -d worker
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
	@docker-compose exec -u postgres postgres  pg_dump --format=custom --compress=6 --dbname=$(POSTGRES_DB) > /backup/$(POSTGRES_DB)_$( date +%Y%m%d%H%M%S ).dump
restore-db:
ifndef file
	@echo "Usage: \n make restore-db file=/xx/yy/zz.dump \n OR\n file=/xx/yy/zz.dump make restore-db"
else
	@docker-compose exec -i -u postgres postgres pg_restore ---dbname=$(POSTGRES_DB) $(file)
endif
clean:
	@echo "Clean Docker images..."
	@docker ps -aqf status=exited | xargs docker rm && docker images -qf dangling=true | xargs docker rmi
foo:
	@echo ""
	@echo "foo is:" $(bar)
install-docker:
	@sh ./bin/install-docker.sh
install-acme:
	@sh ./bin/install-acme.sh

