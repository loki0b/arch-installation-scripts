#!/bin/bash
set -euo

CPU_VENDOR=$(grep -m 1 'vendor_id' /proc/cpuinfo | awk '{print $3}')
if [[ "$CPU_VENDOR" == "AuthenticAMD" ]]; then
	CPU="amd"
elif [[ "$CPU_VENDOR" == "GenuineIntel" ]]; then
	CPU="intel"
fi

# Partition
# Get drive
DRIVE_PATH=$(lsblk -d -n -p -o NAME -e 7,11 | head -n 1)

# sgdisk -> UEFI. Option: sfdisk
# TODO: Use percent notation to partition
sgdisk -Z "$DRIVE_PATH"
sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"EFI" "$DRIVE_PATH"
sgdisk -n 2:0:+4G -t 2:8200 -c 2:"SWAP" "$DRIVE_PATH"
sgdisk -n 3:0:+100G -t 3:8304 -c 3:"ROOT" "$DRIVE_PATH"
sgdisk -n 4:0:0 -t 4:8302 -c 4:"HOME" "$DRIVE_PATH"

# Formating partitions
mkfs.fat -F 32 "$DRIVE_PATH"1
mkswap "$DRIVE_PATH"2
mkfs.btrfs -f "$DRIVE_PATH"3
mkfs.btrfs -f "$DRIVE_PATH"4

# Mouting
mount "$DRIVE_PATH"3 /mnt
mount --mkdir "$DRIVE_PATH"1 /mnt/boot
mount --mkdir "$DRIVE_PATH"3 /mnt/home
swapon "$DRIVE_PATH"2

# TODO: Select mirrors

# packages vim man-db man-pages texinfo wireless-regdb
pacman -Sy archlinux-keyring --noconfirm
pacstrap -K /mnt "base linux linux-firmware nftables iptables-nft $CPU-ucode"
genfstab -U /mnt >> /mnt/etc/fstab

cp script1.sh /mnt
arch-chroot /mnt
rm /mnt/script1.sh
