#!/bin/bash

###
# Добавление шардов и настройка шардирования
###

docker compose exec -T mongos_router mongo --port 27020 --quiet <<EOF
sh.addShard("shard1/shard1:27018");
sh.addShard("shard2/shard2:27019");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name": "hashed" });
EOF

###
# Заполнение БД данными
###

docker compose exec -T mongos_router mongo --port 27020 --quiet <<EOF
use somedb;
for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age: i, name: "ly" + i});
EOF