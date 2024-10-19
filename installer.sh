#!/bin/bash

# * software athor : github.com/miho030
# * software license : GPL2

# checking permission about root
if [ "$(id -u)" -ne "0" ]; then
    echo "[ERROR] This script need root permision." >&2
    exit 1
fi

# check python3.7
if command -v python3.7 >/dev/null 2>&1; then
    echo "[INFO] System already has python3.7"
    python3.7 --version
else
    # install python 3.7 as source make
    echo ""
    echo "[INFO] Installing Python3.7"

    sudo apt-get update -y
    sudo apt-get install build-essential libssl-dev zlib1g-dev libncurses5-dev libnss3-dev libsqlite3-dev libreadline-dev libffi-dev curl libbz2-dev
    cd /usr/src
    sudo wget https://www.python.org/ftp/python/3.7.12/Python-3.7.12.tgz

    sudo tar xzf Python-3.7.12.tgz
    cd Python-3.7.12
    sudo ./configure --enable-optimizations
    sudo make altinstall
fi

# upgrading python3.7 pip
python3.7 -m pip install --upgrade pip


# install AMCS requirements
if [ -f "requirements.txt" ]; then
  python3.7 -m pip install -r requirements.txt
else
  echo "requirements.txt 파일을 찾을 수 없습니다."
  exit 1
fi


# ---------------------------------------------------
# make new account for AMCS service
useradd -m -s /bin/bash malwareCollector

echo "" && echo ""
echo "[INFO] To secure malware collecting environment, AMCS account need new password."
echo "\t > please change new password for AMCS account."
sudo passwd malwareCollector

# Initiate AMCS installation
if [ -f "setup_amcs.py" ]; then
    python3.7 setup_amcs.py
else
    echo "Cannot find AMCS 'installer.py' file in this directory."
    echo "You can install manualy.   ex) python3.7 installer.py"
    exit 1
fi

# change working directoru permission
sudo chown -R malwareCollector:malwareCollector /home/malwareCollector/
sudo chmod -R 700 /home/malwareCollector

echo "" && echo "."&& echo ".." && echo "..."
echo "[INFO] Complete base installation process"
