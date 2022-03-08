#!/bin/bash

#------------------------tunnel parameters------------------------#
# ip address of the other server
REMOTE_IP=192.168.122.56
# wireguard port of the other server
REMOTE_PORT=50000
# local wireguard port
LOCAL_PORT=50000
# local ip address of the tunnel endpoint
LOCAL_TUNNEL_IP=40.40.40.1
# remote ip address of the tunnel endpoint
REMOTE_TUNNEL_IP=40.40.40.2
# interface to be bridged with the l2tp interface
INT_TO_BE_BRIDGED="eth1"
# local private key
LOCAL_PRIVATE_KEY="secret-key"
# remote public key of the other server
REMOTE_PUBLIC_KEY="another-secret-key"
#-----------------------------------------------------------------#

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
wg-quick up wg0
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