#!/bin/bash

# TODO:
# Always check before run a command
# activate wireless-regdb
#pacman -S dosfstools btrfs-progs e2fsprogs fschk helper to mkinitcpio


# TODO: choose localtime
ln -sf /usr/share/zoneinfo/America/Sao_paulo /etc/localtime
hwclock --systohc

# reflector

# TODO: Network
#  Wireless
#config iwd/main.conf
pacman -S iwd iw wireless-regdb --needed --noconfirm
systemctl enable iwd

pacman -S ntp --needed --noconfirm
systemctl enable ntpd

# get interface's name and add
echo -e '[Match]\nName=*\n[Network]\nDHCP=yes' > /etc/systemd/network/99-default.network
systemctl enable systemd-networkd
systemctl enable systemd-resolved
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# TODO: choose keymap and lang
# change console font
sed -i "s/#en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo -e 'KEYMAP=us\nFONT=sun12x22' >> /etc/vconsole.conf

echo Hostname:
read HOSTNAME
echo "$HOSTNAME" > /etc/hostname


# Root password - adding users/passwords
echo root password:
passwd

pacman -S sudo --needed --noconfirm
echo user:
read USER
useradd -m "$USER"
echo "$USER password:"
passwd "$USER"
gpasswd -a "$USER" wheel

# if ssd exists
#systemctl enable fstrim.timer

# TODO: choose between options
pacman -S grub efibootmgr --noconfirm --needed
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch_grub --recheck
grub-mkconfig -o /boot/grub/grub.cfg
