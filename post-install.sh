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

# Variables
pkg_list=""

# Function
add_pkg() {
  while true; do
    read -p "$2 [Y/n]" answer
    answer=${answer:-y}
    case $answer in
      [Yy]* ) pkg_list+="$1 "; break;;
      [Nn]* ) exit;;
      * ) echo "Please answer Y or N";;
    esac
  done
}

clear
echo $'Post install script by Fhilipe\nWould you like to perform the post install configuration? [Y/n]\n'

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  echo "OS: Arch Linux"
  read answer
  if [[ "$answer" == "n" ]]; then
    echo "Bye"
  else
    ## Enable multilib
    echo "=====> Enabling multilib repo"
    sudo sed -i '/multilib\]/,+1 s/^#//' /etc/pacman.conf > /dev/null

    echo "=====> Installing Git"
    yay -Sy git > /dev/null

    ## Clone Dotfiles
    echo "=====> Cloning Dotfiles"
    git clone https://github.com/FhilipeCrash/Dotfiles

    ## Yay install
    echo "=====> Installing Yay"
    {
      git clone https://aur.archlinux.org/yay.git
      cd yay
      makepkg -si
      yay -S yay-git
    } > /dev/null

    ## Enable flatpak support
    echo "=====> Installing Flatpak"
    yay -S flatpak > /dev/null

    ## Zsh install 
    echo "=====> Installing ZSH and Oh My Zsh"
    {
      yay -S zsh
      sudo chsh -s /usr/bin/zsh
      sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
      git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
      git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
      git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
      cp ~/Dotfiles/.zshrc ~/
      cp ~/Dotfiles/.yarnrc ~/
      cp -r ~/Dotfiles/.local/share/applications/ ~/.local/share/
    } > /dev/null

    ## Xorg and drivers install
    echo "=====> Installing Xorg and drivers"
    yay -S xorg-xinit xorg-xinit xorg-xkill xf86-video-intel > /dev/null

    ## Gnome minimal install
    echo "=====> Installing GNOME with mutter-rounded and Gtk theme"
    {
      yay -S gnome-shell gnome-tweak-tool gnome-control-center xdg-user-dirs \
      gdm mutter-rounded gnome-online-accounts nautilus-open-any-terminal \
      flat-remix-gnome flat-remix-gtk papirus-icon-theme papirus-folders-git
    } > /dev/null
 
    ## Gnome tweaks
    echo "=====> Configuring GNOME"
    {
      gsettings set org.gnome.shell.app-switcher current-workspace-only true
      gsettings set org.gnome.desktop.wm.preferences button-layout ‘,close,minimize,maximize:appmenu’
      gsettings set org.gnome.mutter round-corners-radius 12
      gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal alacritty
      gsettings set org.gnome.desktop.interface gtk-theme "Flat-Remix-GTK-Green-Dark"
      gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
      gsettings set org.gnome.shell.extensions.user-theme name "Flat-Remix-Green-Dark-fullPanel" 
      papirus-folders -C teal --theme Papirus-Dark
    } > /dev/null

    ## Install my programs
    echo "=====> Installing all environment programs"
    {
      echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
      curl -O https://download.sublimetext.com/sublimehq-pub.gpg
      sudo pacman-key --add sublimehq-pub.gpg
      sudo pacman-key --lsign-key 8A8F901A
      rm sublimehq-pub.gpg
    } > /dev/null

    add_pkg google-chrome-stable "Install Google Chrome?"
    add_pkg discord "Install Discord?"
    add_pkg telegram-desktop "Install Telegram?"
    add_pkg qbittorrent "Install qBittorrent?"
    add_pkg vlc "Install VLC?"
    add_pkg visual-studio-code-bin "Install VS Code?"
    add_pkg sublime-text "Install Sublime Text?"
    add_pkg "libreoffice-fresh libreoffice-fresh-pt-br" "Install LibreOffice?"
    add_pkg heroic-games-launcher-bin "Install Heroic Games Launcher?"
    add_pkg "steam steam-native-runtime" "Install Steam?"

    while true; do
      read -p "Install Spotify?[Y/n]" answer
      answer=${answer:-y}
      case $answer in
        [Yy]* ) flatpak install flathub com.spotify.Client; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer Y or N";;
      esac
    done
    
    # FIXME This line of code is not working, fix it later
    {
      yay -S $pkg_list alacritty nautilus file-roller unrar unzip p7zip zip gvfs-goa gvfs-google gvfs-mtp \
      wine-staging wine-mono wine-gecko lutris winetricks evince eog gparted gnome-disks \
      baobab gnome-calculator gnome-characters extension-manager qt5ct \
      pipewire pipewire-pulse lib32-pipewire lib32-pipewire-pulse wirepumbler pavucontrol \
      yarn nodejs npm exa
    } > /dev/null

    ## Lunarvim install
    {
      sudo pip install pynvim
      sudo npm i -g neovim
      bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
    } > /dev/null
    
    ## Enable GDM service
    sudo systemctl enable gdm.service > /dev/null
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
    brew install --cask discord spotify google-chrome telegram-desktop visual-studio-code sublime-text qbittorrent vlc
    brew node python
  fi
fi
