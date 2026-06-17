# Venti Imperative Steps

This guide will cover how to set up the Venti machine from different scenarios, from recovery to initial set up. The hardware is assumed to be the same (Beelink EQR5), as well as the disks. If that is not the case, figure out first how to modify the config to make it compatible the new machine/disks.

Before starting, you probably want to recover 2 files:

1. Age key file already registered in `.sops.yaml` - This will unlock the secrets, otherwise they will need to be re-generated, that is outside of the scope of this guide.

2. Service data, as of the current configuration, the data is backed up in the secondary 1.8 TB disk. There should be at least 3 restic repositories, the only ones that matter are: `pandora-self` (may be changed to `venti-self`) and `media-pandora` (may be changed to `media-venti`). Under the `*-self` repository, there should exist the file `/var/lib/sops-nix/key.txt`. In theory the public key listed there, should be present in `.sops.yaml` and can be used for it. If you're me, you should also have the `kazhuha` key somewhere in your workstation. 


## Preparing the System

Depending on the state of the machine, you may not be able to SSH into the server or even get a shell, in that case, booting live from a USB stick is recommended. This assumes that the backup disk has been preserved, if that is not the case, check if there's a backup in any of your HDDs. If you're setting up a new machine, read through these steps and decide which ones are relevant to your situation.

1. Flash a USB stick with > 8 GB of storage with a NixOS minimal image and connect it to the server (powered off). Note that if you use Ventoy or similar tools it will probably not work, it needs to just have that OS.

2. If you're on the Beelink EQR5, spam the F7 key in the keyboard to enter the BIOS, and set the USB port as the highest boot option. Then save changes and reboot.

3. After you power on the machine you should see the kernel boot log scroll by, and then get into a shell. It is advisable to get SSH access as soon as possible purely for convenience reasons. If you don't have an ethernet cable, connect to the network with the following command. If the interface is different, replace `wlp5s0` with whatever wireless interface `ip link` shows.

```sh
wpa_passphrase "SSID" "PASSWORD" | sudo tee /etc/wpa_supplicant.conf
sudo wpa_supplicant -B -i wlp5s0 -c /etc/wpa_supplicant.conf
sudo dhcpcd
```

4. Enable SSH, and get your IP address with:

```sh
sudo passwd nixos
sudo systemctl enable --now sshd
ip addr
```

If you encounter a key mismatch, remove the key by editing `~/.ssh/known_hosts` or by running:

```sh
ssh-keygen -f ".ssh/known_hosts" -R "SSH_ADDRESS"
```

5. From now on, you may run the following steps from your local machine after you SSH into the live environment. Since LUKS is enabled on the main partition, you will need to decrypt it before mounting it. First, identify the blocks with:

```sh
lsblk
```

The name of the disks may vary but it should be similar to this plus your sda from the live USB stick, of the two, the largest will be the backup one (unless I change that in the future)

```txt
[non@venti:~/nixos]$ lsblk
NAME            MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
zd0             230:0    0    32G  0 disk  [SWAP]
nvme1n1         259:0    0   1.8T  0 disk  /mnt/backup <-- BACKUP
nvme0n1         259:1    0 931.5G  0 disk              <-- MAIN
├─nvme0n1p1     259:2    0     1G  0 part  /boot
└─nvme0n1p2     259:3    0 930.5G  0 part              <-- Root
  └─cryptsystem 254:0    0 930.5G  0 crypt
```

This is fork in the road, depending on your situation skip to any of the following headings:

- [Recovering the main partition](#recovering-the-main-partition)
- [Recovering the backup partition](#recovering-the-backup-partition)
- [Installing the config](#installing-the-config)


## Recovering the main partition

1. For this step you will need the LUKS password, hopefully you have it saved somewhere :) In the example above (this may change) MAIN partition would be `nvme0n1p2`.

```sh
sudo cryptsetup luksOpen /dev/MAIN_PARTITION cryptsystem
```

2. Try mounting the main ZFS pool (root pool).

```sh
zpool import -f -R /mnt rpool
zfs list
```

3. You are now able to modify the partition and apply the changes. 

## Recovering the backup partition

The backups are split into several Restic repositories, each encrypted with their own password. 

1. Install any necessary tools. From previous incidents, these are the most common:

```sh
nix-env -iA nixos.ssh-to-age nixos.restic
```

2. Mount the backup disk, and inspect it's contents:

```sh
mkdir /mnt-bak
sudo mount /dev/BACKUP_BLOCK /mnt-bak
sudo ls /mnt-bak
```

You should at least see these 3 directories (unless it has been changed in the future):

```txt
drwxr-x--- 7 backrest backrest  4096 Jan 10 13:10 hot-storage
drwxr-x--- 7 backrest backrest  4096 Jan 10 13:10 media-pandora
drwxr-x--- 7 backrest backrest  4096 Jan 10 13:10 pandora-self
```

|Repository      | Use                                                   |
|----------------|-------------------------------------------------------|
|`hot-storage`   |Relevant but lightweight userfiles from my workstation |
|`media-pandora` |`/srv/media` backup. Heavy files synced in venti       |
|`pandora-self`  |Persistent directories from venti, configs, DBs, etc.  |

3. You may recover the necessary repositories with:

```sh
mkdir ~/bak
sudo restic -r /mnt-bak/REPOSITORY_NAME restore latest --target ~/bak
```

4. Then copy any files from there into the necessary folders. One of the ones that you may want to copy initially will be the age key for the SOPS, so you may run:

```sh
sudo mkdir -p /mnt/persist/var/lib/sops-nix/
sudo cp ~/bak/pandora-self/var/lib/sops-nix/key.txt /mnt/persist/var/lib/sops-nix/
sudo chmod 400 /mnt/var/lib/sops-nix/key.txt
sudo chmod 700 /mnt/persist/var/lib/sops-nix/
sudo chown -R root:root /mnt/persist/var/lib/sops-nix/
```

## Installing the Config


1. If the disk is not yet formatted as indicated in `hosts/venti/disko.nix` then format and mount it:
```sh
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode destroy,format,mount --flake .#venti
```

2. After that step, it is assumed that you have gone through the previous section, or that you have an age key which has a public key listed in `.sops.yaml` already in `/persist/var/lib/sops-nix/key.txt`.

3. Generate the initrd and host SSH keys

```sh
sudo mkdir -p /mnt/persist/etc/initrd/ssh
sudo mkdir -p /mnt/persist/etc/ssh

sudo ssh-keygen -t ed25519 -f /mnt/persist/etc/initrd/ssh/initrd_ed25519_key -N ""
sudo ssh-keygen -t ed25519 -f /mnt/persist/etc/ssh/ssh_host_ed25519_key -N ""
```

5. Build the NixOS system:

```ssh
sudo nixos-install --flake .#venti --no-root-passwd
```

6. Cleanup and power off the server, then when powering it back it, you should land inside it

```
sudo umount -R /mnt
poweroff
```
