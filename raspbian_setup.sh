#!/bin/bash

## Setup Raspbian Node

# Set hostname
echo "test.c-s.io" > /etc/hostname

# Enable ssh access with root
sed -i s/"PermitRootLogin without-password"/"PermitRootLogin yes"/g /etc/ssh/sshd_config
# Restart ssh
systemctl restart ssh

# Set root password (must be logged in as root [sudo su -])
echo 'root:Emmel00rd'|chpasswd

# Sets GPU memory to the minmal, to get more RAM
echo "gpu_mem=16" >> /boot/config.txt

# Update apt-get repos
apt-get update

# Install packages
apt-get install -y htop nano wget net-tools libapparmor1 iotop iftop tar net-tools iptables conntrack traceroute


sh -c 'echo "
interface eth0
static ip_address=10.10.40.7/24
static routers=10.10.40.254
static domain_name_servers=10.10.100.100 10.10.100.110" >> /etc/dhcpcd.conf'


# Disable Firewalld
systemctl disable firewalld

# Remove Pi user
deluser -remove-home pi

# Enable rpcbind
systemctl enable rpcbind

# Start rpcbind
systemctl start rpcbind

# Create nfs mount dir
mkdir -p /mnt/nfs

# Add nfs mount to fstab
echo "nas0.c-s.io:/volume4/swarm_nfs  /mnt/nfs  nfs  rw,relatime,vers=3,rsize=131072,wsize=131072,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=10.10.100.150,mountvers=3,mountport=892,mountproto=udp,local_lock=none,addr=10.10.100.150,noauto,x-systemd.automount  0  0" >> /etc/fstab

# Mount nfs
mount -a

# Check if mount is pressent
mount | grep /mnt/nfs

# Install Docker
curl -sSL https://get.docker.com | sh

# Create or join existing swarm

docker swarm join \
     --token SWMTKN-1-2a9uoco5nxb16iou9o8cngscaakoq3ya3v1oys2cwjngmtkfqe-eupsarzagjjs5yvkmbp042c3u \
     10.10.160.140:2377
