#!/bin/bash

pacman -Sy archlinux-keyring --noconfirm
# cpu amd or intel
pacstrap -K /mnt base linux linux-firmware nftables iptables-nft intel-ucode vim man-db man-pages texinfo wireless-regdb
genfstab -U /mnt >> /mnt/etc/fstab
cp script1.sh /mnt
arch-chroot /mnt
rm /mnt/script1.sh
