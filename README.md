# Vendin_microservices
Vendin microservices repository

## Docker-образы. Микросервисы

- Скачивание исходников микросервисов
- Создание Dockerfile для каждого сервиса
- Сборка образов для каждого сервиса
- Запуск контейнеров для каждого образа
- Помещение контейнеров в общую сеть
- Добавление тома для сохранения данные при пересоздаии контейнеров
- Оптимизация Dockerfile сервиса post за счет использования alpine, как базового образа
- Определение значений ENV через аргументы

```
FROM ruby:2.2-alpine

ENV APP_HOME /app
WORKDIR /$APP_HOME
COPY . /$APP_HOME

RUN apk add --update alpine-sdk \
    && apk add build-base

ADD Gemfile* $APP_HOME/
RUN bundle install
ADD . $APP_HOME

ARG POST_SERVICE_HOST_ARG=post
ARG POST_SERVICE_PORT=5000
ARG COMMENT_SERVICE_HOST=comment
ARG COMMENT_SERVICE_PORT=9292

ENV POST_SERVICE_HOST $POST_SERVICE_HOST_ARG
ENV POST_SERVICE_PORT $POST_SERVICE_PORT_ARG
ENV COMMENT_SERVICE_HOST $COMMENT_SERVICE_HOST_ARG
ENV COMMENT_SERVICE_PORT $COMMENT_SERVICE_PORT_ARG

CMD ["puma"]

```

## Технология контейнеризации. Введение в Docker

- Настройка travic CI по аналогии с репозиторием infra
- Установка Docker
- Создание docker демона в gcloud-e через docker-machine
- Создание образа приложения reddit
- Создание контейнера из образа reddit в gcloude
- Публикация образа в docker hub

