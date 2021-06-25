### Setup redis cluster

```bash
cd cluster
docker-compose up -d
./setup.sh
```

lookup redis cluster info
```bash
docker exec redis-1 redis-cli -p 7001 cluster info
```

### Setup redis failover

```bash
cd failover
docker-compose up -d
```

lookup redis failover info
```bash
docker exec sentinel-1 redis-cli -p 7004 info sentinel
```
