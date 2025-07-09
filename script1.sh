#!/bin/bash

# TODO:
# Always check before run a command
# activate wireless-regdb
#pacman -S dosfstools btrfs-progs e2fsprogs fschk helper to mkinitcpio

ln -sf /usr/share/zoneinfo/America/Sao_paulo /etc/localtime
hwclock --systohc

# choose keymap and lang
sed -i "s/#en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo -e 'KEYMAP=us\nFONT=sun12x22' >> /etc/vconsole.conf

echo Hostname:
read HOSTNAME
echo "$HOSTNAME" >> /etc/hostname
sed -i "/# See hosts(5) for details./a 127.0.0.1\tlocaldomain\n::1\t\tlocaldomain\n127.0.1.1\t$HOSTNAME.localdomain $HOSTNAME" /etc/hosts

# reflector
#config iwd/main.conf
pacman -S iwd ntp --needed --noconfirm

# improve
echo -e '[Match]\nName=*\n[Network]\nDHCP=yes' > /etc/systemd/network/99-default.network

systemctl enable iwd
systemctl enable ntpd
systemctl enable systemd-networkd
systemctl enable systemd-resolved
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# Root password - adding users/passwords
echo root password:
passwd

pacman -S sudo --needed --noconfirm
echo user:
read USER
useradd -m -G wheel "$USER"
echo "$USER password:"
passwd "$USER"
sed -i "s/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/" /etc/sudoers

systemctl enable fstrim.timer

pacman -S grub efibootmgr --noconfirm --needed
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch_grub
grub-mkconfig -o /boot/grub/grub.cfg
