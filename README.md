# Vendin_microservices
Vendin microservices repository

## Kubernetes. Networks ,Storages

- Разбор и ознакомление с тимами Service-ов
- Разбор и ознакомление с ресурсом GCP Ingress
- Разбор и ознакомление работы с сетью в K8s
- Разбор и ознакомление работы с хранилищ в K8s на примере реусурсов PersistentVolume, PersistentVolumeClaim, StorageClass

## Основные модели безопасности и контроллеры в Kubernetes

- Установка Kubernetes
- Установка [Minikube](https://github.com/kubernetes/minikube)
- Обновление .yml файлов k8s для приложения reddit
- Деплой reddit приложения в Minikube и [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine/)
- Описание GKE кластера в terraform-e для развертывания приложения

## Введение в Kubernetes

- Разбор и ознакомление с основными компонентами Kubernetes
- Создание .yml файлов k8s для приложения reddit
- Прохождения курса [Kubernetes The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way)

  Пример Deployment: `post-deployment.yml`

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: post-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: post
  template:
    metadata:
      name: post
      labels:
        app: post
    spec:
      containers:
      - image: post
        name: post
```

## Docker: сети, docker-compose

- Разобраться с типами newtwork
- Развернуть приложение из несколько контейнеров через CLI `docker run`
- Развернуть приложение из нескольких контейнеров через docker compose
- Вынести меняющиеся части в переменные окружения, сделать файл .env.example
- Добавить docker-compose.override.yml:
  1. для монтирования актуального кода приложения
  2. для переопределения процесса в образе comment

*Важные нюансы для задачи со звездочкой:*
https://github.com/docker/compose/issues/4039#issuecomment-255741965
https://github.com/docker/compose/issues/4039#issuecomment-269558432

В файле docker-compose.override.yml используются несколько томов на файлы и папки вместо одного тома на папку, что бы не перетирался vendor, потому что его нет на хостовой машине.

Задать префикс можно через переменную окружения или опцию:

```
  -p, --project-name NAME     Specify an alternate project name
                              (default: directory name)
```

https://github.com/docker/compose/issues/1123#issuecomment-457148264

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

