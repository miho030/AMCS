# Cuckoo SandBox 설치

### Description
```
* datetime : 2023.03.02
* version  : 0.0.0.1

Addtional :
	- Ubuntu network 	 : 브릿지
	- VirtualBox network : host-only 
```

## Installation Guide
* * *

### Install Ubuntu
```shell
depend version(recommended) : Ubuntu 18.0.4LTS
testing version             : Ubuntu 22.04LTS
```
Ubuntu setup (Optional)
```shell
user@host:~$ sudo apt-get update -y && sudo apt-get upgrade -y
user@host:~$ mkdir /home/"""UserHomeDirectory"""/Desktop/cuckoo
```

### 1. Install python version 2
* * *
```shell
user@host:~$ sudo apt-get install python2 python2-pip python2-dev -y
user@host:~$ sudo apt-get install libffi-dev -y
```

### 1. Install libssl version 1.0.0 or 1.0.2g-1ububtu1.8
* * *
```shell
user@host:~$ echo "deb http://security.ubuntu.com/ubuntu focal-security main" | sudo tee /etc/apt/sources.list.d/focal-security.list

user@host:~$ sudo apt-get update
user@host:~$ sudo apt-get install libssl1.0

sudo rm /etc/apt/sources.list.d/focal-security.list
```

#### TroubleShooting
```shell
user@host:~$ wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb
user@host:~$ sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb
```

### Install essential libs
* * *
```shell
user@host:~$ pip2 install virtualenv
user@host:~$ pip2 install setuptools

user@host:~$ sudo apt-get install libjpeg-dev zlib1g-dev swig -y
```

### Install mongodb
* * *
```shell
user@host:~$ wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
user@host:~$ echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

user@host:~$ sudo apt-get update
user@host:~$ sudo apt-get install mongodb-org

user@host:~$ sudo service mongod start
user@host:~$ sudo systemctl enable mongod.service
```

### TroubleShooting
#### solution #1
```shell
user@host:~$ echo "deb http://security.ubuntu.com/ubuntu focal-security main" | sudo tee /etc/apt/sources.list.d/focal-security.list

user@host:~$ sudo apt-get update
user@host:~$ sudo apt-get install libssl1.0

sudo rm /etc/apt/sources.list.d/focal-security.list
```

#### solution #2
```shell
user@host:~$ wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb
user@host:~$ sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb
```

### Install & Setup tcpdump
* * *
```shell
user@host:~$ sudo apt-get install tcpdump apparmor-utils

user@host:~$ sudo aa-disable /usr/bin/tcpdump
user@host:~$ setcap cap_net_raw,cap_net_admin=eip /usr/bin/tcpdump
```

#### TroubleShooting
```shell
user@host:~$ sudo aa-disable /usr/sbin/tcpdump
user@host:~$ setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump 
```

### Install volatility
* * *
```shell
user@host:~$ sudo apt-get update -y && sudo apt-get upgrade -y
user@host:~$ sudo apt-get install dwarfdump build-essential yara zip -y
user@host:~$ sudo apt-get install curl git -y

user@host:~$ curl https://bootstrap.pypa.io/get-pip/2.7/get-pip.py --output get-pip.py

user@host:~$ git clone https://github.com/volatilityfoundation/volatility.git
user@host:~$ cd /volatility
user@host:~/volatility$ sudo python2 setup.py install

user@host:~/volatility$ sudo vol.py --info
```
### Setup volatility (optional)
```shell
user@host:~$ cd ~/volatility/tools/linux/ && make
user@host:~/volatility/tools/linux$ zip $(lsb_release -i -s)_$(uname -r)_profile.zip ./module.dwarf /boot/System.map-$(uname -r)

user@host:~/volatility/tools/linux$ sudo mv $(lsb_release -i -s)_$(uname -r)_profile.zip /usr/local/lib/python2.7/dist-packages/volatility-2.6.1-py2.7.egg/volatility/plugins/overlays/linux/

user@host:~$ wget https://github.com/microsoft/avml/releases/download/v0.2.0/avml-minimal
user@host:~$ chmod +x avml-minimal
user@host:~$ sudo ./avml-minimal memory_dump.lime
```
#### test volatility (optional)
```shell
user@host:~/volatility$ sudo vol.py -f ~/memory_dump.lime --profile=LinuxUbuntu_5_4_0-42-generic_profilex64 linux_pstree
```

### Install m2crypto
* * *
```shell
user@host:~$ sudo pip2 install m2crypto
```

### Install Cuckoo sandbox
* * *
```shell
user@host:~$ sudo pip install cuckoo
user@host:~$ sudo pip install -U cuckoo

user@host:~$ cuckoo community
```

#### Test cuckoo
```
user@host:~$ cuckoo -d
user@host:~$ cuckoo -d

-> if red colored error come out, it's done.
ex) Potentially vulnerable virtualbox version installed. Failed to retrieve its version. Update if version is: 5.2.27
```

### Install virtualbox
```shell
user@host:~$ wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
user@host:~$ wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -

user@host:~$ sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" >> /etc/apt/sources.list.d/virtualbox.list'
```

### execute & setup the virtualbox
```shell
user@host:~$ virtualbox
```
```shell
installation guide
	1. virtualbox option tab -> File -> host network manager -> create host-only network adapter
	2. virtualbox tool tab -> new -> create windows system
	3. floppy drive unload, disable sound/printer etc.. 
	4. execute virtualbox
```

#### troubleshooting
```shell
* if VMWare or virtualbox error comes out like this..
	-> unsopported host cpu / VT-x~~ not executed
	
--
```

### setup virtualbox machine
```shell

```



```
참고

* 설치 가이드 : https://moonit.kr/69

* mongodb 설치 : https://askubuntu.com/questions/1403619/mongodb-install-fails-on-ubuntu-22-04-depends-on-libssl1-1-but-it-is-not-insta
	- 8번 글 확인할 것

* volatility 설치 : https://ssol2-jjanghacker.tistory.com/entry/Ubuntu-2004%EC%97%90-volatility-%EC%84%A4%EC%B9%98
* volarility 설치 시 : https://covert.sh/2020/08/24/volatility-ubuntu-setup/
	- 3번에서 curl https://bootstrap.pypa.io/pip/2.7/get-pip.,py --output get-pip.py



* 추가해야할 것
	elastic search, kibana 연동 구현 관련 가이드 작성해놓기
```