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
    echo "Enabling multilib repo"
    sudo sed -i '/multilib\]/,+1 s/^#//' /etc/pacman.conf

    ## Git install
    sudo pacman -Sy git

    ## Clone Dotfiles
    echo "Cloning Dotfiles"
    git clone https://github.com/FhilipeCrash/Dotfiles

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
    cp ~/Dotfiles/.yarnrc ~/
    cp -r ~/Dotfiles/.local/share/applications/ ~/.local/share/

    ## Xorg and drivers install
    echo "Installing Xorg and drivers"
    yay -S xorg-xinit xorg-xinit xorg-xkill xf86-video-intel 

    ## Gnome minimal install
    echo "Installing GNOME with mutter-rounded and Gtk theme"
    yay -S gnome-shell gnome-tweak-tool gnome-control-center xdg-user-dirs \
      gdm mutter-rounded gnome-online-accounts nautilus-open-any-terminal \
      flat-remix-gnome flat-remix-gtk papirus-icon-theme papirus-folders-git
 
    ## Gnome tweaks
    echo "Configuring GNOME"
    gsettings set org.gnome.shell.app-switcher current-workspace-only true
    gsettings set org.gnome.desktop.wm.preferences button-layout ‘close,minimize,maximize:appmenu’
    gsettings set org.gnome.mutter round-corners-radius 12
    gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal alacritty
    gsettings set org.gnome.desktop.interface gtk-theme "Flat-Remix-GTK-Green-Dark"
    gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
    gsettings set org.gnome.shell.extensions.user-theme name "Flat-Remix-Green-Dark-fullPanel" 
    papirus-folders -C teal --theme Papirus-Dark

    ## Install my programs
    echo "Installing all environment programs"
    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
    curl -O https://download.sublimetext.com/sublimehq-pub.gpg
    sudo pacman-key --add sublimehq-pub.gpg
    sudo pacman-key --lsign-key 8A8F901A
    rm sublimehq-pub.gpg
    yay -Sy alacritty nautilus file-roller unrar unzip p7zip zip gvfs-goa gvfs-google gvfs-mtp \
      google-chrome-stable discord steam telegram-desktop qbittorrent vlc heroic-games-launcher-bin \
      visual-studio-code-bin sublime-text \
      wine-staging wine-mono wine-gecko lutris winetricks \
      evince eog gparted gnome-disks libreoffice-fresh libreoffice-fresh-pt-br \
      baobab gnome-calculator gnome-characters extension-manager qt5ct \
      pipewire pipewire-pulse lib32-pipewire lib32-pipewire-pulse wirepumbler pavucontrol \
      yarn nodejs npm
    flatpak install flathub com.spotify.Client

    ## Lunarvim install
    sudo pip install pynvim
    sudo npm i -g neovim
    bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
    
    ## Enable GDM service
    sudo systemctl enable gdm.service
  fi
  
elif [[ "$OSTYPE" == "darwin" ]]; then
  echo "OS: Mac OS"
  read answer
  if [[ "$answer" == "n" ]]; then
    echo "Bye"
  else
    ## Homebrew install
    echo "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   
    ## Clone Dotfiles
    echo "Cloning Dotfiles"
    git clone https://github.com/FhilipeCrash/Dotfiles

    ## Zsh install
    echo "Installing ZSH and Oh My Zsh"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    cp ~/Dotfiles/.zshrc ~/
    cp ~/Dotfiles/.yarnrc ~/
    
    ## Install useful programs
    echo "Installing all environment programs"
    brew install --cask discord spotify google-chrome telegram-desktop visual-studio-code sublime-text qbittorrent vlc \
      node python
  fi
fi
