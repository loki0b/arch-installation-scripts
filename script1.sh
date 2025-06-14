#!/bin/bash

ln -sf /usr/share/zoneinfo/America/Sao_paulo /etc/localtime
hwclock --systohc
pacman -S ntp --noconfirm
systemctl enable ntp
sed -i "s/#en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo KEYMAP=en >> /etc/vconsole.conf
echo 0x4sg4rd >> /etc/hostname
sed -i '/# See hosts(5) for details./a 127.0.0.1\tlocaldomain' /etc/hosts
sed -i '/127.0.0.1\tlocaldomain/a ::1\t\tlocaldomain' /etc/hosts
sed -i '/::1\t\tlocaldomain/a 127.0.1.1\t0x4sg4rd.localdomain 0x4sg4rd' /etc/hosts
systemctl enable NetworkManager
pacman -S sudo --noconfirm
passwd
useradd -m -G wheel loki0b
passwd loki0b
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
pacman -S grub efibootmgr --noconfirm
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable fstrim.timer
