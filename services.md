# Swarm Services

## DNS Service
```bash
docker service create \
  --name nginx \
  --detach=true \
  --network=pihole \
  --publish 81:80/tcp \
  containerstack/nginx-arm
```
centos
docker service create \
  --name shell \
  --detach=true \
  --network=pihole \
  nginx

## DNS Service
```bash
docker service create \
  --name dns \
  --detach=true \
  --network=dns \
  --network=pihole \
  --dns=127.0.0.1 \
  --publish 53:53/udp \
  --publish 53:53/tcp \
  --mount=type=bind,src=/mnt/nfs/prod/dns/bind,dst=/etc/bind \
  --mount=type=bind,src=/mnt/nfs/prod/dns/named,dst=/var/named \
  --mount=type=bind,src=/mnt/nfs/prod/dns/log,dst=/var/log/named \
  containerstack/dns:arm
```

## Create Pi-hole service
```bash
docker service create \
  --name pihole \
  --detach=true \
  --replicas=1 \
  --network=pihole \
  --publish 8080:80/tcp \
  --publish 54:53/udp \
  --publish 54:53/tcp \
  --env ServerIP=10.10.160.140 \
  --env INTERFACE=eth2 \
  --env WEBPASSWORD=password \
  --env DNS1=8.8.8.8 \
  --env DNS2=8.8.4.4 \
  --mount type=bind,source=/mnt/nfs/prod/pihole/pihole,target=/etc/pihole \
  remonlam/pihole-arm:3.0.1-rc1

  --mount type=bind,readonly=true,source=/mnt/nfs/prod/pihole/setupVars.conf,target=/etc/pihole/setupVars.conf \

  diginc/pi-hole
```
Get ServiceIP from Pihole service
```bash
docker service inspect pihole | grep 10.100.*
```

Update ServerIP ENV with the ServiceIP
```bash
docker service update --env-add ServerIP=10.100.2.2 pihole
```

##10.100.2.2/24

## DHCP Service
```bash
docker service create \
  --name dhcp \
  --detach=true \
  --network=bridge \
  --publish 67:67/udp \
  --publish 67:67/tcp \
  --mount=type=bind,src=/mnt/nfs/prod/dhcp/dhcpd,dst=/etc/dhcp \
  --mount=type=bind,src=/mnt/nfs/prod/dhcp/lease,dst=/var/lib/dhcp \
  containerstack/dhcpd:arm
```


docker swarm join \
    --token SWMTKN-1-3gs1724ehn2euj7c6jsx5ixxygfusgui8qlkrfoj7v7st1dd31-c36czn3kcrnh6kg7udt7qgii5 \
    10.10.160.141:2377




docker network create -d bridge --multihost --config-from bridge dhcp


docker run -d --name dhcpd --net=host -p 67:67 -p 67:67/udp -v /storage/dhcpd:/etc/dhcp containerstack/dhcpd

kernel:[48766.298453] unregister_netdevice: waiting for lo to become free. Usage count = 1

docker service update --image remonlam/pihole-arm:3.0.1-rc1 pihole



           | node0 |
dns1 ----> | node1 | pihole0
           | node2 | pihole1
dns2 ----> | node3 | pihole2
           | node4 |
