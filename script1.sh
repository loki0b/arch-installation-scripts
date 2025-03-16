#!/bin/bash

ln -sf /usr/share/zoneinfo/America/Sao_paulo /etc/localtime
hwclock --systohc
pacman -S ntp --noconfirm
sed -i "s/#en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo KEYMAP=br-abnt2 >> /etc/vconsole.conf
echo arch >> /etc/hostname
sed -i '/# See hosts(5) for details./a 127.0.0.1\tlocaldomain' /etc/hosts
sed -i '/127.0.0.1\tlocaldomain/a ::1\t\tlocaldomain' /etc/hosts
sed -i '/::1\t\tlocaldomain/a 127.0.1.1\tarch.localdomain arch' /etc/hosts
systemctl enable NetworkManager
passwd
useradd -m loki0b
passwd loki0b
pacman -S sudo --noconfirm
sed -i '/root ALL=(ALL:ALL) ALL/a loki0b ALL=(ALL:ALL) ALL' /etc/sudoers
pacman -S grub efibootmgr --noconfirm
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable fstrim.timer
