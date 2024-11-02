# mongo-sharding-repl

Проект для демонстрации шардирования и репликации в MongoDB.

## Как запустить

1. Запустите Docker Compose, чтобы поднять контейнеры MongoDB и приложение:
   ```shell
   docker-compose up -d
   ```

2. Настройка репликации. Запустите скрипт инициализации:

   ```shell
   ./scripts/1 init-replication.sh
   ```

## Как проверить

1. Проверьте количество документов в каждом шарде и общее количество в базе с помощью скрипта тестирования:

   ```shell
   ./scripts/3 tests.sh
   ```

2. Перейдите на http://localhost:8080/docs для документации FastAPI.

Содержание скриптов

- 1 init-replication.sh: Инициализирует репликации и шардирование в MongoDB. 
- 2 fill.sh: Заполняет базу данных somedb коллекцией helloDoc с тестовыми данными. 
- 3 tests.sh: Проверяет корректность данных и распределение документов по шардовым кластерам.