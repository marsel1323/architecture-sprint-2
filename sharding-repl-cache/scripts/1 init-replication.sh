#!/bin/bash

###
# Инициализируем бд
###

docker compose exec -T configSrv mongo --port 27017 --quiet <<EOF
rs.initiate(
  {
    _id : "config-server",
    configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27017" }
    ]
  }
);
EOF

sleep 1

# Инициализация репликации для shard1
docker-compose exec -T shard1-primary mongo --port 27019 --quiet <<EOF
rs.initiate({
  _id: "shard1",
  members: [
    { _id: 0, host: "shard1-primary:27019" },
    { _id: 1, host: "shard1-secondary1:27020" },
    { _id: 2, host: "shard1-secondary2:27021" }
  ]
})
EOF

sleep 1

# Инициализация репликации для shard2
docker-compose exec -T shard2-primary mongo --port 27022 --quiet <<EOF
rs.initiate({
  _id: "shard2",
  members: [
    { _id: 0, host: "shard2-primary:27022" },
    { _id: 1, host: "shard2-secondary1:27023" },
    { _id: 2, host: "shard2-secondary2:27024" }
  ]
})
EOF

# Задержка для инициализации всех подключений
echo "Ожидание инициализации mongos_router..."
sleep 10

# Проверка статуса шардирования
docker compose exec -T mongos_router mongo --port 27018 --quiet <<EOF
sh.status();
EOF

sleep 1
