## winget upgrade --all <- Update all winget apps
## sudo cup all -y <- Update all choco apps

## Allow to run any script
Set-ExecutionPolicy AllSigned -Scope CurrentUser

## Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

## Install packages with choco
choco install sudo neovim -y

## Install PowerShell 7
winget install --id=Microsoft.PowerShell -e

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
winget install --id=RiotGames.LeagueOfLegends.BR -e 
winget install --id=Microsoft.VC++2010Redist-x86 -e 
winget install --id=9NGHP3DX8HDX -e 
winget install --id=9MTFTXSJ9M7F -e
