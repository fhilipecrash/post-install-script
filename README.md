# Post-install script for mine

## Notes from my script
### Todo list
- [ ] Add more functions to make the code cleaner
- [x] Add Arch WSL installation commands in Unix Script
- [ ] Save LunarVim configurations(Windows and Linux)
- [x] Terminate the Mac OS installation script
- [x] Put Windows configuration files on
- [ ] Use dialog on Bash Script
- [ ] Install all yay packages with one command
- [ ] Check if the operation has already been done previously
---
### Usage

#### Arch Linux, Arch WSL and Mac OS

**IMPORTANT**: Use this script on a fresh system install, when using on Arch it is preferable that it is after creating your user

```shell
$ ./post-install.sh
```

#### Windows
```powershell
.\post-install.ps1
```
---
### Features
- ##### Arch Linux
  - Enable multilib on pacman
  - Install Yay grabber
  - Install Flatpak support
  - Install Zsh and configure Oh My Zsh
  - Install Xorg and Gnome minimal
  - Configure Gnome themes and behavior
  - Install all my programs
  - Install LunarVim
  - Enable systemd services
- ##### Windows
  - Allows unsafe script installations
  - Install PowerShell 7 and configure Oh My Posh
  - Install PowerShell Modules
  - Install Winget packages
  - Install Scoop packages
  - Install LunarVim
  - Install WSL2
  - Install Arch WSL container
  - Configure Arch WSL
  - Install Zsh and configure Oh My Zsh on Arch
  - Install LunarVim on Arch
- ##### Mac OS
  - Install Homebrew
  - Install and configure Oh My Zsh
  - Install packages with Brew
  - Install GUI packages with Brew Cask

