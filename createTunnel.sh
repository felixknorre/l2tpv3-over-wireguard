#!/bin/bash

REMOTE_IP=192.168.122.56
LOCAL_TUNNEL_IP=40.40.40.1
REMOTE_TUNNEL_IP=40.40.40.2
LOCAL_PORT=50000
REMOTE_PORT=50000
INT_TO_BE_BRIDGED="lo"
LOCAL_PRIVATE_KEY="eLmKy8orvR6vvDqxR9eGpS+lF/hUwhou8Rdv0BDIp2s="
REMOTE_PUBLIC_KEY="eHcvc8wmTT9u5RLObckaPsQr/3uTzKlG9obNLUZfMmc="

# create wiregurad config
cat << EOF > /etc/wireguard/wg0.conf
[Interface]
PrivateKey = ${LOCAL_PRIVATE_KEY}
ListenPort = ${LOCAL_PORT}
Address = ${LOCAL_TUNNEL_IP}/24

[Peer]
PublicKey = ${REMOTE_PUBLIC_KEY}
AllowedIPs = ${REMOTE_TUNNEL_IP}/32
Endpoint = ${REMOTE_IP}:${REMOTE_PORT}
EOF

# start wireguard
wg-quick up 
# autostart wireguard tunnel after boot
systemctl enable wg-quick@wg0ct

# create l2tp tunnel and session over wireguard tunnel
ip l2tp add tunnel tunnel_id 1 peer_tunnel_id 1 \
    encap ip \
    local $LOCAL_TUNNEL_IP remote $REMOTE_TUNNEL_IP 

ip l2tp add session tunnel_id 1 session_id 1 peer_session_id 1
ip link set l2tpeth0 up mtu 1500

# bridge interface with l2tp interface
ip link add brtrunk type bridge
ip link set l2tpeth0 master brtrunk
ip link set $INT_TO_BE_BRIDGED master brtrunk
ip link set brtrunk up