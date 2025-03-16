#!/bin/bash

pacstrap -K /mnt base linux linux-firmware intel-ucode vim networkmanager man-db man-pages texinfo 
genfstab -U /mnt >> /mnt/etc/fstab
cp script1.sh /mnt
arch-chroot /mnt
rm /mnt/script1.sh
