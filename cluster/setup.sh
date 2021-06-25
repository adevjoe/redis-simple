#!/bin/bash

# meet
for i in $(seq 1 6)
do
  REDIS_IP[$i]=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' redis-$i)
  docker exec redis-1 redis-cli -p 7001 cluster meet ${REDIS_IP[$i]} 700$i
done

# add slots
docker exec redis-1 redis-cli -p 7001 cluster addslots {0..5461}
docker exec redis-2 redis-cli -p 7002 cluster addslots {5462..10922}
docker exec redis-3 redis-cli -p 7003 cluster addslots {10923..16383}

# set slave
docker exec redis-4 redis-cli -p 7004 cluster replicate $(docker exec redis-1 redis-cli -p 7001 cluster nodes | grep ${REDIS_IP[1]} | awk '{print $1}')
docker exec redis-5 redis-cli -p 7005 cluster replicate $(docker exec redis-1 redis-cli -p 7001 cluster nodes | grep ${REDIS_IP[2]} | awk '{print $1}')
docker exec redis-6 redis-cli -p 7006 cluster replicate $(docker exec redis-1 redis-cli -p 7001 cluster nodes | grep ${REDIS_IP[3]} | awk '{print $1}')

# restart redis-cluster-proxy
docker stop redis-cluster-proxy && docker start redis-cluster-proxy
