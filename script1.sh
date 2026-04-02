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

# TODO: System
pacman -S polkit --needed --noconfirm

# TODO: choose between options
pacman -S grub efibootmgr --noconfirm --needed
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch_grub --recheck
grub-mkconfig -o /boot/grub/grub.cfg

# TODO: User Specific

pacman -S vim man-db man-pages

# Audio
pacman -S pipewire wireplumber pipewire-audio --needed --noconfirm

# Bluetooth
sudo pacman -S bluez bluez-utils pipewire-pulse --needed --noconfirm

#misc
pacman -S rtkit upower xdg-desktop-portal --needed --noconfirm
pacman -S libcamera pipewire-libcamera --needed --noconfirm

systemctl enable bluetooth.service
systemctl enable pipewire.service pipewire-pulse.service wireplumber.service
systemctl enable upower


pacman -S xorg-server xorg-xinit xorg-xrandr xdg-utils i3 dmenu xclip alacritty
cp /etc/X11/xinit/xinitrc ~/.xinitrc

pacman -S git base-devel --needed --noconfirm
pacman -S openssh --needed --noconfirm


