#!/bin/bash

pacman -Sy archlinux-keyring --noconfirm
pacstrap -K /mnt base linux linux-firmware iptables-nft intel-ucode vim man-db man-pages texinfo
genfstab -U /mnt >> /mnt/etc/fstab
cp script1.sh /mnt
arch-chroot /mnt
rm /mnt/script1.sh
