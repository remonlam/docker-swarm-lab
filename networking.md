# Swarm Networking

## Create overlay network
```shell
docker network create \
  --driver overlay \
  --subnet 10.100.0.0/24 \
  overlay-multi-host-network
```
