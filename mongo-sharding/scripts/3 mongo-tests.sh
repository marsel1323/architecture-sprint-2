#!/bin/bash

###
# Тестирование БД: подсчет документов в каждом шарде
###

echo "Подсчет документов в шарде 1:"
docker compose exec -T shard1 mongo --port 27018 --quiet <<EOF
use somedb;
db.helloDoc.count();
EOF

echo "Подсчет документов в шарде 2:"
docker compose exec -T shard2 mongo --port 27019 --quiet <<EOF
use somedb;
db.helloDoc.count();
EOF

echo "Подсчет общего количества документов через маршрутизатор:"
docker compose exec -T mongos_router mongo --port 27020 --quiet <<EOF
use somedb;
db.helloDoc.count();
EOF