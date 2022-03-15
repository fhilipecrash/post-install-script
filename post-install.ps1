<#
.SYNOPSIS
  Post-install script for Windows configuration
.DESCRIPTION
  Script that configures my entire working environment on Windows,
  installing programs with winget, installing scoop along with some utilities
  and configuring Windows Terminal, PowerShell, LunarVim and WSL2
.NOTES
  Version:        0.1
  Author:         Fhilipe Coelho <coelhocrash11@gmail.com>
  Creation Date:  2022-03-11
  Purpose/Change: Help configuring my desktop in Windows  
#>
## winget upgrade --all <- Update all winget apps
## scoop update -a <- Update all scoop apps

## Install PowerShell 7
Write-Output "Installing PowerShell 7 and Oh My Posh"
winget install --id=Microsoft.PowerShell -e
winget install --id=JanDeDobbeleer.OhMyPosh -e

## Install PowerShell Modules
Install-Module PSReadLine -AllowPrerelease -Force
Install-Module -Name Terminal-Icons -Repository PSGallery
Install-Module -Name z

## Install packages with winget
Write-Output "Installing winget packages"
winget install --id=OpenJS.NodeJS -e
winget install --id=Git.Git -e
winget install --id=Python.Python.3 -e
winget install --id=Microsoft.VisualStudioCode -e
winget install --id=Discord.Discord -e
winget install --id=Valve.Steam -e
winget install --id=VideoLAN.VLC -e
winget install --id=Spotify.Spotify -e
winget install --id=Telegram.TelegramDesktop -e
winget install --id=Google.Chrome -e
winget install --id=TheDocumentFoundation.LibreOffice -e
winget install --id=Adobe.Acrobat.Reader.64-bit -e
winget install --id=7zip.7zip -e
winget install --id=qBittorrent.qBittorrent -e
winget install --id=SublimeHQ.SublimeText.4 -e
winget install --id=Oracle.JavaRuntimeEnvironment -e
winget install --id=Mega.MEGASync -e
winget install --id=Stremio.Stremio -e
winget install --id=CPUID.CPU-Z -e
winget install --id=Microsoft.VC++2010Redist-x86 -e
winget install --id=9NGHP3DX8HDX -e

## Allow to run any script
Set-ExecutionPolicy AllSigned -Scope CurrentUser

## Install Scoop
Write-Output "Installing Scoop"
Invoke-WebRequest -useb get.scoop.sh | Invoke-Expression

## Install packages with scoop
Write-Output "Installing scoop packages"
scoop install sudo neovim gcc make curl wget lua fzf

## Install LunarVim
Write-Output "Installing LunarVim"
Invoke-WebRequest https://raw.githubusercontent.com/LunarVim/LunarVim/master/utils/installer/install.ps1 -UseBasicParsing | Invoke-Expression
