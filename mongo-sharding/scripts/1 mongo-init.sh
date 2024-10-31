#!/bin/bash

###
# Инициализация базовой конфигурации MongoDB для шардирования
###

# Инициализация config server
docker compose exec -T configSrv mongo --port 27017 --quiet <<EOF
rs.initiate({
  _id: "config-server",
  configsvr: true,
  members: [{ _id: 0, host: "configSrv:27017" }]
})
EOF

# Инициализация репликаций шардов
docker compose exec -T shard1 mongo --port 27018 --quiet <<EOF
rs.initiate({
  _id: "shard1",
  members: [{ _id: 0, host: "shard1:27018" }]
})
EOF

docker compose exec -T shard2 mongo --port 27019 --quiet <<EOF
rs.initiate({
  _id: "shard2",
  members: [{ _id: 0, host: "shard2:27019" }]
})
EOF

# Задержка для инициализации всех подключений
echo "Ожидание инициализации mongos_router..."
sleep 10

# Проверка статуса шардирования
docker compose exec -T mongos_router mongo --port 27020 --quiet <<EOF
sh.status();
EOF