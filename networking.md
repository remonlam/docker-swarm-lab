# Swarm Networking

## Create overlay network
For more information about overlay networking please check out [link to doc].

### Create empty network
```shell
docker network create \
  --driver overlay \
  --subnet 10.100.0.0/24 \
  stuff
```

### Create DNS network
```shell
docker network create \
  --driver overlay \
  --subnet 10.100.1.0/24 \
  dns
```

### Create Pi-hole network
```shell
docker network create \
  --driver overlay \
  --subnet 10.100.2.0/24 \
  pihole
```

### Create nginx network
```shell
docker network create \
  --driver overlay \
  --subnet 10.100.3.0/24 \
  nginx
```
