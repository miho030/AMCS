
<h1 align="center">
  <br>
  <a href="http://www.amitmerchant.com/electron-markdownify"><img src="https://raw.githubusercontent.com/amitmerchant1990/electron-markdownify/master/app/img/markdownify.png" alt="Markdownify" width="200"></a>
  <br>
  daily Malware Collecting Software (dMCS)
  <br>
</h1>

<h4 align="center">AOI::dMCS , <a href="https://github.com/miho030" target="_blank">Github Profile</a></h4>

<p align="center">
  <a href="#">
    <img src="https://img.shields.io/badge/LANG-SHELL-E34F26?style=for-the-badge&logo=HTML5n&logoColor=white">
  </a>
  <a href="#">
    <img src="https://img.shields.io/badge/COMPILER-vi-3776AB?style=for-the-badge&logo=HTML5n&logoColor=white">
  </a>
</p>

<p align="center">
  <a href="#about">About</a> •
  <a href="#Testing Requirements">Requirements</a> •
  <a href="#Structure">Usage</a> •
  <a href="#related">Related</a>
</p>

![AMCS_Test_Vid1](./resource/dMCS_Test_Vid.gif)


## About

```
AMCS (Automatic Malware Collecting Service),
AMCS can provide bunch of malware samples at every day just for you!
```

To be a good malware analyst, have to experience analyzing a wide variety of samples directly. However in reality, the first difficulty that people who dream of becoming a malware analyst face is getting a fresh malware samples.

So, it's designed to build your own malware collection server by only using any linux platform and this program, jsut 2 tools.

```
Happy hunting!
```

## Installation
```
  1. grant permission to installer.sh file
    $ sudo chmod +x installer.sh

  2. execute installer file
    $ sudo ./installer.sh

  3. when the installer.sh file done thier process,
     AMCS program will automatically download malware archive 
     files at '/home/malwareCollector/AMCS/~' with EVERY DAY at AM 01:00
```


## Requirements

```
  - Any linux system (with bash/usb terminal)
  - spare store device (ex:hdd/ssd/flash)
```

* Test onboard
```
  - Test complete in raspberry pie envrironment.
  - Test complete in Ubuntu (x64) 20.04 LTS
```




## Usage
```
bash

  $ sudo chmod +x daily_dMCS.sh
  $ sudo ./daily_dMCS.sh
```

* Structure

```bash
├─src
│  ├─ daily_dMCS.sh
│  └─ all_dMCS.sh
│
└─README.md
```

## Related
[MalwareBazaar](https://bazaar.abuse.ch/api/) - MalwareBazaar API document



## License
CopyRight all reserved by github.com/miho030

---

> GitHub [@miho030](https://github.com/miho030) &nbsp;&middot;&nbsp;
> Twitter [@jp_rennka](https://twitter.com/jp_Rennka)

