#!/usr/bin/env bash

# INCOMPLETE!!!

echo "This script is meant to be run from a live-usb stick from the server machine VENTI (do not try to run on any other machine! as of the current version)"
echo "You will need to have a secret age key already registered in `.sops.yaml` in the location `/home/nixos/key.txt`"
echo "Only proceed if the file is ready and you are in the correct environment"
echo "!! Warning!! This will WIPE the main disk!!"

read -p 'Proceed? Type PROCEED' proceed

if [[ "${proceed}" != "PROCEED" ]]; then
    exit 1
fi

cd /home/nixos

echo "Running checks"
# Try to find the main disk by ID
# Try to find the flake.nix in nixos
# Try to find key.txt and its contents in ~


echo "Setting up the disko partitions"
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode mount --flake .#venti

echo "Copying the Sops key to its correct location"
sudo mkdir -p /mnt/persist/var/lib/sops-nix/
sudo cp /home/nixos/key.txt /mnt/persist/var/lib/sops-nix/key.txt

echo "Generating initrd SSH key"
sudo mkdir -p /mnt/persist/etc/initrd/ssh
sudo ssh-keygen -t ed25519 -f /persist/etc/initrd/ssh/initrd_ed25519_key -N ""

echo "Generating the SSH host key"
sudo ssh-keygen -t ed25519 -f /persist/etc/ssh/ssh_host_ed25519_key -N ""

echo "Mounting the disko partitions"
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode mount --flake .#venti

echo "Building the NixOS system"
sudo nixos-install --flake .#venti --no-root-passwd

echo "Setup complete! Press any key to reboot into the live machine (remember to take out the liveUSB stick!)"
sudo umount -R /mnt
poweroff
