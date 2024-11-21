#!/bin/sh

# Скрипт первоначального запуска и инициализации проекта

COMMAND="docker compose exec -u www app"
DIR_LARAVEL="application/laravel"
DIR_KOEL="application/koel"

test ! -f ".env" && cp .env.example .env

clear

echo "          Список"
echo "          ------"
echo "Выберите интересующий вас проект:"
echo
echo "[K]oel"
echo "[L]aravel"
echo

read project

docker compose stop; docker compose down
docker pull composer:latest

case "$project" in
	"K" | "k" )
	echo "Выбран проект koel"

	sed -i 's/^APP_NAME=.*/APP_NAME=koel/1' .env

	mkdir -p ${DIR_KOEL}
	git clone git@github.com:koel/koel.git	${DIR_KOEL}

	docker compose up -d --build
	${COMMAND} composer install
	${COMMAND} php artisan key:generate
	${COMMAND} php artisan config:cache
	${COMMAND} php artisan koel:init --no-assets
	${COMMAND} npm install
	${COMMAND} npm run build

	echo; echo "http://localhost:80"
	echo "Default authorization data:"
	echo "\tadmin@koel.dev"
	echo "\tKoelIsCool"
	;;
	
	"L" | "l" )
	echo "Выбран проект laravel"

	sed -i 's/^APP_NAME=.*/APP_NAME=laravel/1' .env

	mkdir -p ${DIR_LARAVEL}
	composer create-project --prefer-dist laravel/laravel ${DIR_LARAVEL}

	docker compose up -d --build
	${COMMAND} composer install --no-dev
	${COMMAND} php artisan key:generate
	${COMMAND} php artisan config:cache
	${COMMAND} php artisan migrate

	echo; echo "http://localhost:80"
	;;

	* )
	echo "Не определён проект"
	;;
esac	
