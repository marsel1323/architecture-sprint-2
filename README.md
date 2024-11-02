# pymongo-api

## Как запустить проект

Для запуска финальной конфигурации проекта с шардированием, репликацией MongoDB и кэшированием Redis, выполните следующие шаги.

### 1. Запуск MongoDB, Redis и приложения

Перейдите в директорию `sharding-repl-cache` и запустите все сервисы с помощью команды:
    
```shell
docker compose up -d
```

### 2. Инициализация репликации и шардирования в MongoDB

Запустите скрипт инициализации:
    
```shell
./scripts/1_init-replication.sh
```

### 3. Заполнение MongoDB тестовыми данными

После инициализации запустите скрипт для заполнения данных:

```shell
./scripts/2_fill.sh
```

## Как проверить

### Локально

Откройте в браузере http://localhost:8080

### На виртуальной машине

1.	Узнайте IP-адрес виртуальной машины:
    
```shell
curl --silent http://ifconfig.me
```
    
2.	Откройте в браузере http://<ip виртуальной машины>:8080

### Доступные эндпоинты

Полный список эндпоинтов доступен на [Swagger UI](http://<ip виртуальной машины>:8080/docs).

Основной эндпоинт для проверки кэша: /helloDoc/users. Повторный запрос к этому эндпоинту должен выполняться быстрее (<100 мс), если данные успешно кэшируются.

## Файл схемы

Итоговая схема с результатом всех заданий хранится в [task1.drawio](./task1.drawio) и отображает всю архитектуру проекта.