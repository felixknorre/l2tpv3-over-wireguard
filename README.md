# l2tpv3-over-wireguard

This repository contains scripts for creating a layer 2 site-to-site tunnel. To create a secure layer 2 tunnel, the L2TPv3 and Wireguard protocols are combined. The layer 2 traffic is encapsulated by L2TPv3 and then transmitted via an encrypted wireguard tunnel.

## Prerequisites
The scripts were tested with Ubuntu 21.10 and requires the following software packages:

* linux-headers-*
* wireguard

The required software can be installed with the following script:

```bash
sudo ./installPrerequisites.sh
```

## Usage
After the required software has been installed, a key pair can be generated using the following script. The key pair is located in `/etc/wireguard/`.

```bash
sudo ./generateKeypair.sh
```

Before the tunnel can be created, the tunnel parameters must be set. Open the file `createTunnel.sh` and adjust the parameters. After that the script can be executed.

```bash
sudo ./createTunnel.sh 
``` 

Now the layer 2 tunnel should be functional.