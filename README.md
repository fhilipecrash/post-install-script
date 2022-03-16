# Post-install script for mine

## Notes from my script
### Todo list
- [ ] Add more functions to make the code cleaner
- [x] Add Arch WSL installation commands in Unix Script
- [ ] Save LunarVim configurations(Windows and Linux)
- [x] Terminate the Mac OS installation script
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

**IMPORTANT**: Use this script on a fresh system install, when using on Arch it is preferable that it is after creating your user

---
### Usage

#### Arch Linux, Arch WSL and Mac OS
```shell
$ ./post-install.sh
```

#### Windows
```powershell
.\post-install.ps1
```
