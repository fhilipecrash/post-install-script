## Allow to run any script
Set-ExecutionPolicy AllSigned -Scope CurrentUser

## Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

## Install Python
wget https://www.python.org/ftp/python/3.10.2/python-3.10.2-amd64.exe -OutFile python.exe
python.exe /quiet

## Install sudo
choco install sudo -y

## Installing useful programs
sudo choco install
