#!/bin/bash

# interface
echo "#===============================================#"
echo "          Daily Malware sample downloader        "
echo "                 {  malIDCMaker  }"
echo ""
echo "                     - Author  : AOI (@jp_Rennka)"
echo "                     - Version : v-0.0.1.3"
echo "#===============================================#"
echo ""
echo ""
echo ""

# make malware dataCenter
echo "[*] Entering malware IDC repository.."
cd ../malDataCenter
if [ $? -eq 0 ]; then
        echo "Entering malware DataCenter.."
        echo ""
else
        echo "[!] Create malware repo directory"
        mkdir ../malDataCenter
        cd ../malDataCenter
        echo ""
fi
echo "+-------------------------------------------------+"
echo ""

# make all(malNoa) malware dataCenter
cd ../malDataCenter/malNoa
if [ $? -eq 0 ]; then
        echo "Entering daily malware DataCenter.."
        cur=$(pwd)
        echo "current location is, "$cur""
        echo ""
else
        echo "[!] Create daily malware repo directory"
        mkdir ./malNoa
        cd ./malNoa
        echo ""
fi
echo "+--------------------------------------------------+"
echo ""

# download all of malware sample from malwarebazaar
for i in {20,21}; do
        for j in {01,02,03,04,05,06,07,08,09,10,11,12}; do
                for k in {01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31}; do
                        wget -N https://mb-api.abuse.ch/downloads/20"$i-$j-$k".zip
                done
        done
done

echo ""
echo ""
echo ""
echo "download complete..!"

