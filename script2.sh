#!/bin/bash

#TODO
# set mkinitcpio
# set resolver
#

#nmap, wireshark, tcpdump, openvpn, strongswan, tor, torsocks, traceroute, strace, ltrace

network() {}

dev() {
    sudo pacman -S base-devel --needed --noconfirm
    sudo pacman -S git openssh --needed --noconfirm
    sudo pacman -S docker docker-compose docker-buildx --needed --noconfirm
    sudo systemctl enable docker.socket
}

misc() {
    sudo pacman -S lsof tmux htop valgrind strace dosfstools usbutils pkgfile dmidecode --needed --noconfirm
}

virtual_machine() {
	
}

paru() {
	local PACMAN_CONF_PATH='/etc/pacman.conf'
	local PARU_CONF_PATH='/etc/paru.conf'

    if [[ ! -x paru ]]; then
        git clone https://aur.archlinux.org/paru.git
	cd paru
    	makepkg -si
        # Testing makepkg -sic
    	paru --gendb
        paru -c --noconfirm
    	sudo sed -i 's/#Color/Color/' $PACMAN_CONF_PATH
    	sudo sed -i 's/#BottomUp/BottomUp/' $PARU_CONF_PATH
	rm -rf "$HOME/.cargo"
        cd ..
        echo "Paru installation completed"
    else
        echo "Paru already installed"
    fi
}

user() {
	sudo pacman -S zsh --needed --noconfirm
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	sudo pacman -S firefox obsidian --needed --noconfirm
}

# TODO: User Specific

# Audio
sudo pacman -S pipewire wireplumber pipewire-audio --needed --noconfirm
sudo systemctl --user enable pipewire.service pipewire-pulse.service wireplumber.service

# Bluetooth
sudo pacman -S bluez bluez-utils pipewire-pulse --needed --noconfirm
sudo systemctl enable bluetooth.service

#misc
sudo pacman -S rtkit upower xdg-desktop-portal --needed --noconfirm
sudo pacman -S libcamera pipewire-libcamera --needed --noconfirm
sudo systemctl enable upower

sudo pacman -S xorg-server xorg-xinit xorg-xrandr xdg-utils i3 dmenu xclip alacritty
sudo cp /etc/X11/xinit/xinitrc ~/.xinitrc

dev
misc
