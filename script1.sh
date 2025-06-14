#!/bin/bash
HOSTNAME='0x4sg4rd'
ETHERNET=$(ip link | grep enp | cut -d ' ' -f 2 | cut -d ':' -f 1)

# reflector

ln -sf /usr/share/zoneinfo/America/Sao_paulo /etc/localtime
hwclock --systohc

sed -i "s/#en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo KEYMAP=en >> /etc/vconsole.conf
echo "$HOSTNAME" >> /etc/hostname
sed -i '/# See hosts(5) for details./a 127.0.0.1\tlocaldomain' /etc/hosts
sed -i '/127.0.0.1\tlocaldomain/a ::1\t\tlocaldomain' /etc/hosts
sed -i "/::1\t\tlocaldomain/a 127.0.1.1\t$HOSTNAME.localdomain $HOSTNAME" /etc/hosts

pacman -S iwd nftables ntp --noconfirm
touch /etc/systemd/network/20-wired.network
echo '[Match]' >> /etc/systemd/network/20-wired.network
sed -i "/[Match]/a Name=$ETHERNET\n\n[Network]\nDHCP=yes"
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

pacman -S sudo --noconfirm
pacman -S grub efibootmgr --noconfirm

systemctl enable systemd-networkd
systemctt enable systemd-resolvd
# TODO: systemctl enable ntp.service
systemctl enable fstrim.timer

passwd
useradd -m -G wheel loki0b
passwd loki0b
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch_grub
grub-mkconfig -o /boot/grub/grub.cfg
