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
#
# Changelog:
#
#
#   v0.1 2022-03-09, Fhilipe Coelho:
#      - First version with some tweaks to Arch Linux install
#
# License: GPL v3.
#
echo $'Post install script by Fhilipe\nWould you like to perform the post install configuration? [Y/n]\n'


if [[ "$OSTYPE" == "linux-gnu" ]]; then
  echo "OS: Arch Linux"
  read answer
  if [[ "$answer" == "n" ]]; then
    echo "Bye"
  else
    ## Enable multilib
    # Use SED to uncomment multilib on /etc/pacman.conf

    ## Git install
    sudo pacman -Sy git

    ## Yay install
    echo "Installing Yay"
    cd /tmp/
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    yay -S yay-git

    ## Enable flatpak support
    yay -S flatpak

    ## Zsh install 
    echo "Installing ZSH and Oh My Zsh"
    yay -S zsh
    sudo chsh -s /usr/bin/zsh
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    cp ~/Dotfiles/.zshrc ~/

    ## Xorg and drivers install
    echo "Installing Xorg and drivers"
    yay -S 

    ## Gnome minimal install
    echo "Installing GNOME with mutter-rounded"
    yay -S gnome-shell gnome-tweak-tool gnome-control-center xdg-user-dirs gdm mutter-rounded
    
    ## Gnome tweaks
    gsettings set org.gnome.shell.app-switcher current-workspace-only true
    gsettings set org.gnome.desktop.wm.preferences button-layout ‘close,minimize,maximize:appmenu’
    gsettings set org.gnome.mutter round-corners-radius 12

    ## Install useful programs
    echo "Installing all environment programs"
    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
    curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
    yay -Sy alacritty nautilus file-roller unrar unzip p7zip zip \
      google-chrome-stable discord steam telegram-desktop qbittorrent vlc heroic-games-launcher-bin visual-studio-code-bin sublime-text \
      wine-staging wine-mono wine-gecko lutris winetricks \
      evince eog gparted gnome-disks libreoffice-fresh libreoffice-fresh-pt-br
    flatpak install flathub com.spotify.Client
  fi
  
elif [[ "$OSTYPE" == "darwin" ]]; then
  echo "OS: Mac OS"
fi
