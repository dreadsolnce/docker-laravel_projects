#!/bin/sh

# Скрипт первоначального запуска и инициализации проекта

COMMAND="docker compose exec -u www app"
DIR_LARAVEL="application/laravel"
DIR_KOEL="application/koel"

test ! -f ".env" && cp .env.example .env

clear
k=$1
if [ -n $k ] && [ "$k" = "-l" ] || [ "$k" = "-L" ]; then
  #echo "project=Laravel"
  project="l"
elif [ "$k" = "-k" ] || [ "$k" = "-K" ]; then
  #echo "project=Koel"
  project="k"
elif [ -z "$k" ]; then
  echo "          Список"
  echo "          ------"
  echo "Выберите интересующий вас проект:"
  echo
  echo "[K]oel"
  echo "[L]aravel"
  echo

  read project
fi

docker compose stop; docker compose down
if ! docker images | grep -iP ^composer >/dev/null ; then
  #cho "composer нет"
  docker pull composer:latest
fi

case "$project" in
	"K" | "k" )
	echo "Выбран проект koel"

	sed -i 's/^APP_NAME=.*/APP_NAME=koel/1' .env

        mkdir -p ${DIR_KOEL} 
	if [ ! -f ${PWD}/${DIR_KOEL}/README.md ]; then
	    git clone git@github.com:koel/koel.git ${DIR_KOEL}
	    if [ $? -ne 0 ]; then
	      # echo "Нет доступа к git по ssh"
	      # echo "Клонируем по протоколу https"
	      git clone https://github.com/koel/koel.git ${DIR_KOEL}
	      if [ $? -ne 0 ]; then
	          echo "Не возможно склонировать репозиторий!"
		  exit 1
	      fi
	   fi
	fi
	
	if [ ! -f ${PWD}/${DIR_KOEL}/README.md ]; then
	  docker compose up -d --build
	  ${COMMAND} composer install
	  ${COMMAND} php artisan key:generate
	  ${COMMAND} php artisan config:cache
	  ${COMMAND} php artisan koel:init --no-assets
	  ${COMMAND} npm install
	  ${COMMAND} npm run build
	else
	  docker compose up -d 
	fi  

	echo; echo "http://localhost:80"
	echo "Default authorization data:"
	echo "\tadmin@koel.dev"
	echo "\tKoelIsCool"
	;;
	
	"L" | "l" )
	echo "Выбран проект laravel"

	sed -i 's/^APP_NAME=.*/APP_NAME=laravel/1' .env

	if [ ! -f ${PWD}/${DIR_LARAVEL}/README.md ]; then
	    rm -rf ${PWD}/${DIR_LARAVEL} 
	    mkdir -p ${PWD}/${DIR_LARAVEL}
            if  apt-cache policy composer | grep Installed | grep none >/dev/null; then
                #echo "Пакет composer не установле"
	        sudo apt install composer -y
	    fi
	    composer create-project --prefer-dist laravel/laravel ${DIR_LARAVEL}

	    docker compose up -d --build
	    ${COMMAND} composer install --no-dev
	    ${COMMAND} php artisan key:generate
	    ${COMMAND} php artisan config:cache
	    ${COMMAND} php artisan migrate
	else
	    docker compose up -d
	fi

	echo; echo "http://localhost:80"
	;;

	* )
	echo "Не определён проект"
	;;
esac	
