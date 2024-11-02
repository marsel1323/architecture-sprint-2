#!/bin/bash

###
# Ожидание готовности mongos_router
###

echo "Ожидание готовности mongos_router..."
until docker compose exec -T mongos_router mongo --port 27018 --quiet --eval "db.adminCommand('ping')" &> /dev/null; do
  echo "mongos_router не готов, повторная проверка через 5 секунд..."
  sleep 5
done

echo "mongos_router готов, начинаем настройку шардирования и заполнение базы."


###
# Добавление шардов и настройка шардирования
###

docker compose exec -T mongos_router mongo --port 27018 --quiet <<EOF
sh.addShard("shard1/shard1-primary:27019");
sh.addShard("shard2/shard2-primary:27022");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name": "hashed" });
EOF

###
# Заполнение БД данными
###

docker compose exec -T mongos_router mongo --port 27018 --quiet <<EOF
use somedb;
for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age: i, name: "ly" + i});
EOF