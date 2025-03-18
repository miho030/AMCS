#!/bin/bash

# * software athor : github.com/miho030
# * software license : GPL2

# checking permission about root
# check python3.12
if command -v python3.12 >/dev/null 2>&1; then
    echo "[INFO] System already has python3.12"
    python3.12 --version
else
    # install python 3.12 as source make
    echo ""
    echo "[INFO] Installing Python 3.12"

    # 필수 패키지 설치
    sudo apt update -y
    sudo apt install -y build-essential libssl-dev zlib1g-dev \
        libncurses5-dev libnss3-dev libsqlite3-dev libreadline-dev \
        libffi-dev curl libbz2-dev liblzma-dev libgdbm-dev libmpdec-dev \
        libuuid1 tk-dev libncursesw5-dev libxml2-dev libxmlsec1-dev libexpat1-dev

    # Python 3.12 소스 다운로드 및 컴파일
    cd /usr/src
    sudo wget https://www.python.org/ftp/python/3.12.2/Python-3.12.2.tgz
    sudo tar xzf Python-3.12.2.tgz
    cd Python-3.12.2

    # 최적화 옵션을 활성화하고 빌드
    sudo ./configure --enable-optimizations
    sudo make -j$(nproc)
    sudo make altinstall

    echo "[INFO] Python 3.12 installation completed."
fi

# upgrading python3 pip with --break-system-packages
python3.12 -m pip install --upgrade --force-reinstall pip --break-system-packages

# install AMCS requirements with --break-system-packages
if [ -f "requirements.txt" ]; then
    python3.12 -m pip install -r requirements.txt --break-system-packages
else
    echo "[ERROR] requirements.txt 파일을 찾을 수 없습니다."
    exit 1
fi



# ---------------------------------------------------
# make new account for AMCS service
echo "" && echo ""
echo "[INFO] Making new linux account for manage AMCS packages.."
useradd -m -s /bin/bash malwareCollector

# grant permission for edit crontab for malwareCollecter user
echo "malwareCollector" | sudo tee -a /etc/cron.allow


echo "" && echo ""
echo "[INFO] To secure malware collecting environment, AMCS account need new password."
echo "\t > please change new password for AMCS account."
sudo passwd malwareCollector

# Initiate AMCS installation
if [ -f "setup_amcs.py" ]; then
    python3 setup_amcs.py
else
    echo "Cannot find AMCS 'installer.py' file in this directory."
    echo "You can install manualy.   ex) python3 installer.py"
    exit 1
fi

# change working directoru permission
sudo chown -R malwareCollector:malwareCollector /home/malwareCollector/
sudo chmod -R 700 /home/malwareCollector

echo "" && echo "."&& echo ".." && echo "..."
echo "[INFO] Complete base installation process"
