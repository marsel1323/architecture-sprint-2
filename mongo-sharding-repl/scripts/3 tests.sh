#!/bin/bash

###
# Тестирование БД: подсчет документов в каждом шарде
###

# Проверка документов в shard1
echo "Подсчет документов в shard1-primary:"
docker compose exec -T shard1-primary mongo --port 27019 --quiet <<EOF
use somedb;
db.helloDoc.count();
EOF

echo "Подсчет документов в shard1-secondary1:"
docker compose exec -T shard1-secondary1 mongo --port 27020 --quiet <<EOF
use somedb;
rs.secondaryOk();
db.helloDoc.count();
EOF

echo "Подсчет документов в shard1-secondary2:"
docker compose exec -T shard1-secondary2 mongo --port 27021 --quiet <<EOF
use somedb;
rs.secondaryOk();
db.helloDoc.count();
EOF

# Проверка документов в shard2
echo "Подсчет документов в shard2-primary:"
docker compose exec -T shard2-primary mongo --port 27022 --quiet <<EOF
use somedb;
db.helloDoc.count();
EOF

echo "Подсчет документов в shard2-secondary1:"
docker compose exec -T shard2-secondary1 mongo --port 27023 --quiet <<EOF
use somedb;
rs.secondaryOk();
db.helloDoc.count();
EOF

echo "Подсчет документов в shard2-secondary2:"
docker compose exec -T shard2-secondary2 mongo --port 27024 --quiet <<EOF
use somedb;
rs.secondaryOk();
db.helloDoc.count();
EOF

# Проверка общего количества документов через маршрутизатор
echo "Подсчет общего количества документов через маршрутизатор:"
docker compose exec -T mongos_router mongo --port 27018 --quiet <<EOF
use somedb;
db.helloDoc.count();
EOF