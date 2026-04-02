#!/bin/bash

#TODO
# set mkinitcpio
# install dosfstools
# investigate firmware
# set systemd units
# config time zone and ntp
# config vms
# dmidecode
# set ssh env
# codium + ext and settings
# install notofonts
# usbutils

audio_bluetooth() {
    	
	# Audio
	sudo pacman -S pipewire wireplumber pipewire-audio --needed --noconfirm
    	# Bluetooth
    	sudo pacman -S bluez bluez-utils pipewire-pulse --needed --noconfirm
    
   	#misc
	sudo pacman -S rtkit upower xdg-desktop-portal --needed --noconfirm
	sudo pacman -S libcamera pipewire-libcamera --needed --noconfirm

	sudo systemctl enable --now bluetooth.service
	systemctl enable --now pipewire.service pipewire-pulse.service wireplumber.service
	sudo systemctl enable --now upower
}

misc() {
    sudo pacman -S git base-devel --needed --noconfirm
    sudo pacman -S openssh --needed --noconfirm
    #sudo pacman -S lsof tmux htop valgrind strace  --needed --noconfirm
}

xorg_i3() {
    sudo pacman -S xorg-server xorg-xinit xorg-xrandr i3 dmenu xclip alacritty
    sudo cp /etc/X11/xinit/xinitrc ~/.xinitrc
}

# fix
paru() {
    if [[ ! -x paru ]]; then
        git clone https://aur.archlinux.org/paru-bin.git
	cd paru-bin
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

user() {
	sudo pacman -S zsh --needed --noconfirm
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	sudo pacman -S firefox obsidian --needed --noconfirm

}


audio_bluetooth
misc
xorg_i3
user
