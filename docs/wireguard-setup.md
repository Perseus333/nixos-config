# Wireguard Setup

## Adding a new client

To add a new client you will need to modify 3 configs:

- The config file for your client (`xiao.conf`) which you will load (either in /etc/wireguard/ or in the WireGuard app) when enabling wireguard on that client.
- The client identifier in `/hosts/xiao/wireguard.nix` in the `peers` block (`conf_for_xiao.txt`), and the client ID in `secret_names`.
- The `secrets/services/wireguard.yaml` (`line_for_sops.txt`), to append the pre-shared key.

To make life easier for you, below is a script that will generate all configs and place them in your current directory under `deleteAfterUse/`. You should run it in a trusted machine which has the `wireguard-tools` installed.

```bash
#!/usr/bin/env bash

# Constants, remember to update
xiaoPubIP="87.106.83.12"
xiaoWgIP="10.8.0.1"
mask="10.8.0"
wgPort="1558"
mtu="1280"
keepAlive="25"
xiaoPubKey="6Sf+v5/ZpUFXK4BKaz5GrxafGe3V2VXkSPpAKs1seC8="

# Variables
read -p "Client ID (short name, dash-case):" clientID
read -p "Client num (single digit, unused by other clients):" clientNum


clientPrivKey=$(wg genkey)
clientPubKey=$(echo "$clientPrivKey" | wg pubkey)
preSharedKey=$(wg genkey)

# Config generator
conf_for_client=$(cat << EOF
[Interface]
PrivateKey = ${clientPrivKey}
Address = ${mask}.${clientNum}/32
DNS = ${xiaoWgIP}
MTU = ${mtu}

[Peer]
PublicKey = ${xiaoPubKey}
PresharedKey = ${preSharedKey}
AllowedIPs = ${mask}.0/24
Endpoint = ${xiaoPubIP}:${wgPort}
PersistentKeepalive = ${keepAlive}
EOF
)

conf_for_xiao=$(cat << EOF
{
  # ${clientID}
  publicKey = "${clientPubKey}"
  presharedKeyFile = config.sops.secrets.wg-${clientID}-psk.path;
  allowedIPs = [ "${mask}.${clientNum}/32" ];
}
EOF
)

line_for_sops="wg-${clientID}-psk: ${preSharedKey}"

# Output
mkdir -p deleteAfterUse
echo "$conf_for_client" > deleteAfterUse/xiao.conf
echo "$conf_for_xiao"   > deleteAfterUse/conf_for_xiao.txt
echo "$line_for_sops"   > deleteAfterUse/line_for_sops.txt
chmod 700 deleteAfterUse
chmod 600 deleteAfterUse/*
```
