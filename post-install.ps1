## winget upgrade --all <- Update all winget apps
## scoop update -a <- Update all scoop apps

## Install PowerShell 7
winget install --id=Microsoft.PowerShell -e

## Install PowerShell Modules
Install-Module PSReadLine -AllowPrerelease -Force
Install-Module -Name Terminal-Icons -Repository PSGallery
Install-Module -Name z

## Install packages with winget
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
iwr -useb get.scoop.sh | iex

## Install packages with scoop
scoop install sudo neovim gcc make wget lua fzf

## Install LunarVim
iwr https://raw.githubusercontent.com/LunarVim/LunarVim/master/utils/installer/install.ps1 -UseBasicParsing | iex
