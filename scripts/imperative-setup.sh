#!/usr/bin/env bash

# INCOMPLETE!!!

echo "Generating initrd SSH host key"
ssh-keygen -t ed25519 -f /persist/etc/initrd/ssh/initrd_ed25519_key -N ""