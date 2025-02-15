# docker-laravel_projects-postgres-nginx-rabbitmq-redis
+ Проект создан для запуска различных готовых проектов основанных на фреймворк laravel с помощью одного единственного файла docker-compose.yml

# Предварительные условия
* Запущенный Docker на хостовой машине.
* Запущенный Docker compose на хостовой машине.
* Базовые знания по работе с Docker 

# Описание и структура проекта:
* application - каталог с проектами
* data - каталог для хранения баз данных проектов
* dockerfile - каталог с docker файлами проектов. Файлы следует именовать: <название проекта>_Dockerfile
* sourcefile - каталог с конфигурационными файлами для используемых сервисов
* .env.example - файл с используемыми переменными окружения. Некоторые переменные из этого файла необходимо переопределить в соответствии с вашими требованиями до выполнения скрипта script.sh. Либо после изменять файл .env
* docker-compose.yml - основной файл с используемыми сервисами.
* script.sh - скрипт инициализации проекта(ов). С помощью данного скрипта выполняется начальная инициализация проекта: скачивание проекта в папку application и выполнение необходимых настроек приложения app. В данном скрипте уже прописаны два проекта koel и laravel. При создании нового проекта отредактируйте (создайте) новое меню на подобии уже прописанных в нем проектов laravel и koel

# Установка
+ Clone the repo.
+ chmod +X script.sh
+ `script.sh` - выполнить инициализацию проекта.
+ Выбор запускаемого проекта с помощью команды docker compose up -d осуществляется путём редактирования файла .env. Для проекта koel необходимо изменить APP_NAME=koel и DIR_MUSIC=<каталог с музыкальными файлами на хостовой машине>. Для проекта laravel: APP_NAME=laravel и закомментировать переменную DIR_MUSIC.
+ Запустите `docker-compose up -d` для запуска контейнеров.

# Используемы images:
+ redis:alpine
+ postgres:9.5-alpine
+ rabbitmq:3-management-alpine
+ nginx:alpine
+ php:8.2-fpm



