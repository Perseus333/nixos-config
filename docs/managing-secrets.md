# Managing Secrets

You should never include secrets in plain text in the repository, EVER. This configuration uses sops-nix to allow for encrypting secrets inside the config.
The secrets are accessible with AGE keys which in turn are derived from SSH keys. Care should be taken to not allow regular user SSH keys (eg. ~/.ssh/) keys from unlocking secrets, particularly those keys from the servers. As such, SSH host keys based on ed25519 are used. 

## Managing keys

The private and public AGE keys are derived and stored with the following script which already places the keys in their correct location and with appropriate settings. The key is ESSENTIAL for unlocking the machine and losing or damaging it may prevent you from regaining access to your server (talking from experience), as such, extra care has been put to prevent modifications.

```bash
#!/usr/bin/env bash
set -euo pipefail

mkdir -p /var/lib/sops-nix

nix run nixpkgs#ssh-to-age -- -i /etc/ssh/ssh_host_ed25519_key.pub | {
  read -r PUBKEY
  PRIVKEY=$(sudo nix run nixpkgs#ssh-to-age -- -private-key -i /etc/ssh/ssh_host_ed25519_key)

  cat <<EOF | sudo tee /var/lib/sops-nix/key.txt > /dev/null
# created: $(date -u +%Y-%m-%dT%H:%M:%SZ)
# from: /etc/ssh/ssh_hosts_ed25519_key
# public key: ${PUBKEY}
${PRIVKEY}
EOF
}

sudo chown root:root /var/lib/sops-nix
sudo chmod 400 /var/lib/sops-nix/key.txt
sudo chattr +i /var/lib/sops-nix/key.txt
```

IF you need to make modifications to this key, particularly for key rotation, you should first disable the immutable attribute from the file and then modify it with root:

```sh
sudo chattr -i /var/lib/sops-nix/key.txt
```

It is highly recommended to keep a universal, well-protected key, outside of the mentioned hosts, for emergency reasons. Preferably the key should be derived from a hardware key to prevent theft and, if possible, split with Shamir's secret sharing algorithm accross multiple hosts with at least one airgapped.

## Creating new secrets

When creating new secrets place them according to the established structure, and apply the least priviledge principle, meaning that if a host doesn't need access to a secret, then it shouldn't get it. 

```
secrets/
├── hosts
├── users
├── services
└── shared
```

Secrets which are host-specific, particularly it's private keys, should be placed in the appropriate `secrets/hosts/HOST.yaml`. That file should only be accessible with the ssh host key of that host.

If a user has specific secrets, such as it's password hash, then it should be placed in `secrets/users/USER.yaml`. In this case, provided that the user is distributed accross several machines should list all ssh host keys necessary.

Any secrets pertaining to a single service should be inside services in `secrets/services/SERVICE.yaml`. Some services may require `.env` files, just remember to specify that with the `format` option. Access should be managed for the entire `secrets/services/` directory under the host keys of hosts with the `server` role.

If a secret needs to be shared accross multiple hosts, or users, then that file should be placed under `secrets/shared` and the necessary host keys should be specified.

## Updating keys

If you wish to update the keys, you can do so with the following command. This assumes that the key that you're updating is not the one being used to re-encrypt the files.

```sh
find secrets/ -type f \( -name "*.yaml" -o -name "*.yml" -o -name "*.json" -o -name "*.env" \) -exec sudo sops updatekeys -y {} \;
```

If a key is not accessible with your current host key, you may specify it:

```sh
SOPS_AGE_KEY_FILE=<(sudo cat /OTHER/HOST/KEY.txt) sops updatekeys SECRETS_FILE.yaml
```


If you're trying to replace your own host key, then you'll need to run it with the general key with:

```sh
SOPS_AGE_KEY_FILE=<(sudo cat /GENERAL/KEY/LOCATION.txt) find secrets/ -type f \( -name "*.yaml" -o -name "*.yml" -o -name "*.json" -o -name "*.env" \) -exec sops updatekeys -y {} \;
```

## Checking keys

Remembering what age key corresponds to what ssh key is very hard, as such, you can verify what's the public key of your private age key, or your SSH keys with the following commands:

From a private AGE key:

```sh
age-keygen -y /PATH/PRIVATE/AGE/KEY.txt
```

From a public SSH key:

```sh
ssh-to-age -i /PATH/PUBLIC/SSH/KEY
```

From a private SSH key:

```sh
ssh-keygen -y -f /PATH/PRIVATE/SSH/KEY | ssh-to-age
```
