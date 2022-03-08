#!/bin/bash

cd /etc/wireguard/

if test -f privatekey; then
    rm privatekey
    echo "old privatekey removed."
fi

if test -f publickey; then
    rm publickey
    echo "old publickey removed."
fi

umask 077; wg genkey | tee privatekey | wg pubkey > publickey


PRIVATE_KEY=$(<privatekey)
PUBLIC_KEY=$(<publickey)

echo "Private key: $PRIVATE_KEY"
echo "Public key: $PUBLIC_KEY"

cd -