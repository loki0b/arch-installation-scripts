#!/bin/bash

#TODO
# config time zone and ntp

ZSHRC='~/.zshrc'
PACMAN_CONF_PATH='/etc/pacman.conf'
PARU_CONF_PATH='/etc/paru.conf'

tmp_dir() {
    if [[ ! -d tmp ]]; then
        mkdir tmp
    fi
    cd tmp
}

audio_bluetooth() {
    sudo pacman -S pipewire wireplumber pipewire-audio --needed --noconfirm
    sudo pacman -S bluez bluez-utils pipewire-pulse --needed --noconfirm
    sudo systemctl enable bluetooth.service
}

misc() {
    sudo pacman -S git base-devel --needed --noconfirm
    sudo pacman -S openssh --needed --noconfirm
    sudo pacman -S lsof tmux htop valgrind strace neovim usbutils --needed --noconfirm
    sudo pacman -S network-manager-applet pavucontrol --needed --noconfirm
    sudo pacman -S obsidian neovim firefox --needed --noconfirm
}

xorg_i3() {
    sudo pacman -S xorg-server xorg-xinit xorg-xrandr i3 dmenu xclip alacritty
    sudo cp /etc/X11/xinit/xinitrc ~/.xinitrc
}

paru() {
    if [[ ! -x paru ]]; then
        git clone https://aur.archlinux.org/paru.git ~/
	cd paru
    	makepkg -si
        # Testing makepkg -sic
    	paru --gendb
        paru -c --noconfirm
    	sudo sed -i 's/#Color/Color/' $PACMAN_CONF_PATH
    	sudo sed -i 's/#BottomUp/BottomUp/' $PARU_CONF_PATH
        cd ..
        echo "Paru installation completed"
    else
        echo "Paru already installed"
    fi
}

zsh() {
	local NEW_THEME='ZSH_THEME="gentoo"'
	local PLUGINS='plugins=(git zsh-syntax-highlighting)'

	sudo pacman -S zsh --needed --noconfirm
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	# Theme
    sed -i "s/ZSH_THEME=\"robbyrussell\"/$NEW_THEME" $ZSHRC
	# Syntax highlighting
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    sed -i "s/plugins=(git)/PLUGINS" $ZSHRC
}

clean() {
    rm -rf ~/.cargo
}

sudo pacman -S iwd nftables --needed --noconfirm
sudo pacman -Rnsdd wap_supplicant iptables
sudo systemctl enable ntp.service --now

tmp_dir
audio_bluetooth
#misc
xorg_i3
paru
zsh
clean
