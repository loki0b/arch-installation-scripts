#!/bin/bash

ln -sf /usr/share/zoneinfo/America/Sao_paulo /etc/localtime
hwclock --systohc

sed -i "s/#en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo -e 'KEYMAP=us\nFONT=sun12x22' >> /etc/vconsole.conf

echo Hostname:
read HOSTNAME
echo "$HOSTNAME" >> /etc/hostname
sed -i '/# See hosts(5) for details./a 127.0.0.1\tlocaldomain' /etc/hosts
sed -i '/127.0.0.1\tlocaldomain/a ::1\t\tlocaldomain' /etc/hosts
sed -i "/::1\t\tlocaldomain/a 127.0.1.1\t$HOSTNAME.localdomain $HOSTNAME" /etc/hosts

#pacman -S dosfstools btrfs-progs e2fsprogs fschk helper to mkinitcpio
# reflector
#pacman -Rnsdd iptables --noconfirm
#config iwd/main.conf
pacman -S iwd ntp --needed --noconfirm

touch /etc/systemd/network/99-default.network
echo -e '[Match]\n\n[Network]\nDHCP=yes' >> /etc/systemd/network/99-default.network #wip

systemctl enable iwd
systemctl enable ntpd
systemctl enable systemd-networkd
systemctt enable systemd-resolved
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
