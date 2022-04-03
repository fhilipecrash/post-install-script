#!/bin/bash
#
# post-install.sh - Post-install script for Arch Linux and Mac configuration
#
# Author : Fhilipe Coelho <coelhocrash11@gmail.com>
# GitHub : https://github.com/FhilipeCrash/post-install-script
#
# ---------------------------------------------------------------
# This program is made to perform the configuration of the user's
# work environment, it is recommended to use it on a newly 
# installed system.
# On Arch Linux installation, use without having any desktop
# environment or window manager installed.
#
# --------------------------------------------------------------
#
# HOW TO USE?
#   $ ./post-install.sh
#
# License: GPL v3.
#
# Changelog:
#   v0.1 2022-03-16, Fhilipe Coelho:
#      - Initial version with support to Arch Linux, Mac OS and Arch WSl

################### VARIABLES ###################
PKG_LIST=""
DIALOGRC="dialog-colors"
BLUE="\033[1;34m"
NORMAL="\033[0m"
BOLD="\033[1m"

################### FUNCTIONS ###################
add_pkg() {
	while true; do
		read -p "$2 [Y/n]" answer
		answer=${answer:-y}
		case $answer in
		[Yy]* ) PKG_LIST+="$1 "; break;;
		[Nn]* ) exit;;
		* ) echo -e "Please answer Y or N";;
		esac
	done
}

install_ohmyzsh() {
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	cp ~/Dotfiles/.zshrc ~/
	cp ~/Dotfiles/.yarnrc ~/
}

install_yay() {
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
	yay -S yay-git
}

install_lunarvim() {
	sudo pip install pynvim
	sudo npm i -g neovim
	bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
}

initial_screen() {
    dialog                                           \
        --stdout                                     \
	    --backtitle "Post-install script" 			 \
   	    --title "OS detected: $1"              \
   	    --yesno "\nWould you like to perform the post install configuration?" 8 50
}

################### MAIN ###################
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    initial_screen "Arch Linux"
	if [[ $? == "0" ]]; then
		## Enable multilib
		echo -e "${BLUE}=====> ${NORMAL} ${BOLD}Enabling multilib repo${NORMAL}"
		sudo sed -i '/multilib\]/,+1 s/^#//' /etc/pacman.conf

		echo -e "${BLUE}=====> ${NORMAL} ${BOLD}Installing Git${NORMAL}"
		yay -Sy git

		## Clone Dotfiles
		echo -e "${BLUE}=====> ${NORMAL} ${BOLD}Cloning Dotfiles${NORMAL}"
		git clone https://github.com/FhilipeCrash/Dotfiles

		## Yay install
		echo -e "${BLUE}=====> ${NORMAL} ${BOLD}Installing Yay${NORMAL}"
		install_yay

		## Enable flatpak support
		echo -e "${BLUE}=====> ${NORMAL} ${BOLD}Installing Flatpak${NORMAL}"
		yay -S flatpak

		## Zsh install 
		echo -e "${BLUE}=====> ${NORMAL} ${BOLD}Installing ZSH and Oh My Zsh${NORMAL}"
		yay -S zsh
		chsh -s /usr/bin/zsh
		install_ohmyzsh
		cp -r ~/Dotfiles/.local/share/applications/ ~/.local/share/

		## Xorg and drivers install
		echo -e "${BLUE}=====> ${NORMAL} ${BOLD}Installing Xorg and drivers${NORMAL}"
		yay -S xorg-xinit xorg-xinit xorg-xkill xf86-video-intel

		## Gnome minimal install
		echo -e "${BLUE}=====> ${NORMAL} ${BOLD}Installing GNOME with mutter-rounded and Gtk theme${NORMAL}"
		yay -S gnome-shell gnome-tweak-tool gnome-control-center xdg-user-dirs \
		gdm mutter-rounded gnome-online-accounts nautilus-open-any-terminal \
		flat-remix-gnome flat-remix-gtk papirus-icon-theme papirus-folders-git
	
		## Gnome tweaks
		echo -e "${BLUE}=====> ${NORMAL} ${BOLD}Configuring GNOME${NORMAL}"
		gsettings set org.gnome.shell.app-switcher current-workspace-only true
		gsettings set org.gnome.desktop.wm.preferences button-layout ‘appmenu:minimize,maximize,close,’
		gsettings set org.gnome.mutter round-corners-radius 12
		gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal alacritty
		gsettings set org.gnome.desktop.interface gtk-theme "Flat-Remix-GTK-Violet-Dark"
		gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
		gsettings set org.gnome.shell.extensions.user-theme name "Flat-Remix-Violet-Dark-fullPanel"
		papirus-folders -C violet --theme Papirus-Dark

		## Install my programs
		echo -e "${BLUE}=====> ${NORMAL} ${BOLD}Installing all environment programs${NORMAL}"
		echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
		curl -O https://download.sublimetext.com/sublimehq-pub.gpg
		sudo pacman-key --add sublimehq-pub.gpg
		sudo pacman-key --lsign-key 8A8F901A
		rm sublimehq-pub.gpg

		add_pkg google-chrome "Install Google Chrome?"
		add_pkg discord "Install Discord?"
		add_pkg telegram-desktop "Install Telegram?"
		add_pkg qbittorrent "Install qBittorrent?"
		add_pkg vlc "Install VLC?"
		add_pkg visual-studio-code-bin "Install VS Code?"
		add_pkg sublime-text "Install Sublime Text?"
		add_pkg "libreoffice-fresh libreoffice-fresh-pt-br" "Install LibreOffice?"
		add_pkg heroic-games-launcher-bin "Install Heroic Games Launcher?"
		add_pkg "steam steam-native-runtime" "Install Steam?"
		add_pkg spotify "Install Spotify?"
		
		yay -S $PKG_LIST alacritty nautilus file-roller unrar unzip p7zip zip gvfs-goa gvfs-google gvfs-mtp \
		wine-staging wine-mono wine-gecko lutris winetricks evince eog gparted gnome-disk-utility \
		baobab gnome-calculator gnome-characters extension-manager qt5ct \
		pipewire pipewire-pulse pipewire-alse lib32-pipewire wireplumber pavucontrol \
		yarn nodejs npm exa

		## LunarVim install
		echo -e "${BLUE}=====> ${NORMAL} ${BOLD}Installing LunarVim${NORMAL}"
		install_lunarvim
		
		## Enable GDM service
		sudo systemctl enable gdm.service
		sudo systemctl enable pipewire-pulse.service
	else
		echo -e "Bye"
	fi
	
	elif [[ "$OSTYPE" == "darwin" ]]; then 
	echo -e "OS: Mac OS\n"
	read -p "Would you like to perform the post install configuration? [Y/n]" answer
	answer=${answer:-y}
	if [[ "$answer" == [Yy] ]]; then
		## Homebrew install
		echo -e "${BLUE}=====> ${NORMAL} ${BOLD}Installing Homebrew${NORMAL}"
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	
		## Clone Dotfiles
		echo -e "${BLUE}=====> ${NORMAL} ${BOLD}Cloning Dotfiles${NORMAL}"
		git clone https://github.com/FhilipeCrash/Dotfiles

		## Zsh install
		echo -e "${BLUE}=====> ${NORMAL} ${BOLD}Installing ZSH and Oh My Zsh${NORMAL}"
		install_ohmyzsh

		## Install useful programs
		echo -e "${BLUE}=====> ${NORMAL} ${BOLD}Installing all environment programsi${NORMAL}"
		brew install --cask discord spotify google-chrome telegram-desktop visual-studio-code sublime-text qbittorrent vlc
		brew install node python yarn exa
	else
		echo -e "Bye"
	fi
	elif [[ $(grep Microsoft /proc/version) ]]; then 
	echo -e "OS: Arch Linux WSL\n"
	read -p "Would you like to perform the post install configuration? [Y/n]" answer
	answer=${answer:-y}
	if [[ "$answer" == [Yy] ]]; then
		## Arch WSL initial configuration
		echo -e "${BLUE}=====> ${NORMAL} ${BOLD}Arch WSL initital configuration${NORMAL}"
		passwd
		echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel
		pacman -S zsh
		useradd -m -G wheel -s /usr/bin/zsh fhilipe
		passwd fhilipe
		config --default-user fhilipe
		sudo pacman-key --init
		sudo pacman-key --populate
		sudo pacman -Syy archlinux-keyring 

		## Install Oh My Zsh
		echo -e "${BLUE}=====> ${NORMAL} ${BOLD}Installing ZSH and Oh My Zsh${NORMAL}"
		install_ohmyzsh
		
		## Install Yay
		echo -e "${BLUE}=====> ${NORMAL} ${BOLD}Installing Yay${NORMAL}"
		install_yay

		## Install environment packages
		echo -e "${BLUE}=====> ${NORMAL} ${BOLD}Installing all environment programs${NORMAL}"
		yay -S npm yarn nodejs python lua exa

		## Install LunvarVim
		echo -e "${BLUE}=====> ${NORMAL} ${BOLD}Installing LunarVim${NORMAL}"
		install_lunarvim
	else
		echo -e "Bye"
	fi
fi

