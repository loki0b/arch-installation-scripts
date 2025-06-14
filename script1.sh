#!/bin/bash
HOSTNAME='0x4sg4rd'
ETHERNET_INTERFACE=$(ip link | grep enp | cut -d ' ' -f 2 | cut -d ':' -f 1)

pacman -S iwd nftables sudo ntp --noconfirm
pacman -S grub efibootmgr --noconfirm
pacman -Rnsdd iptables --noconfirm

systemctl enable ntpd
# reflector

# Root password - adding users/passwords
echo user:
read USER

echo root password:
passwd
useradd -m -G wheel "$USER"
echo "$USER password:"
passwd "$USER"

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

touch /etc/systemd/network/20-wired.network
echo '[Match]' >> /etc/systemd/network/20-wired.network
sed -i "/[Match]/a Name=$ETHERNET_INTERFACE\n\n[Network]\nDHCP=yes"
systemctl enable systemd-networkd
systemctt enable systemd-resolved
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch_grub
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable fstrim.timer
