#!/bin/bash

# Global variable
today=`date`
shelterMountPoint=/mnt/malIDC_repository/
shelterDir=/mnt/malIDC_repository/malDataCenter/
dailyDir=/mnt/malIDC_repository/malDataCenter/daily/
daily_date=$(date --date="yesterday" +%Y-%m-%d)
fName="$daily_date".zip
lfName="$dailyDir$fName"

rootPwd=$(pwd)

logDir="$rootPwd"/log/daily/
logfName="$daily_date"_daily.log
dailyLog="$logDir$logfName"

mountLog="$logDir"_mount.log

# interface
echo ""
echo ""

echo "                 _ ___ ____   ____          ___   ____  " 
echo " _ __ ___   __ _| |_ _|  _ \ / ___| __   __/ _ \ |___ \ " 
echo "| '_   _ \ / _  | || || | | | |     \ \ / / | | |  __) |"
echo "| | | | | | (_| | || || |_| | |___   \ V /| |_| | / __/ "
echo "|_| |_| |_|\__,_|_|___|____/ \____|   \_/  \___(_)_____|"

echo ""
echo ""

echo "#======================================================#"
echo "             Daily Malware sample downloader            "
echo ""
echo "          Author : AOI (@jp_Rennka)      ver : v-0.1.1.1"
echo "#======================================================#"
echo ""
echo ""

echo "[INFO] Initiating malIDC protocol"
echo ""

echo "+------------------------------------------------------+"
echo ""

# Making daily log file
echo "[INFO] Initiate checking daily log file..."
if [ ! -e $dailyLog ]; then
        echo "[*] Createing daily log file.."
        touch $dailyLog
        touch $mountLog
else
        echo "  [+] Complete checking log file with no ploblem." 2>> $dailyLog
fi
echo ""

# Check environment
echo "[INFO] Initiate checking environment..."
if [ ! -d $logDir ]; then
        echo "  [!] log directory not founded !"
        echo "  [*] Create log directory.."
        mkdir ./log
        mkdir $logDir
        echo "  [+] Complete create log directory"
else
        echo "  [+] Complete check environment with no ploblem." 2>> $dailyLog

fi
echo ""

# Making daily log file
echo "[INFO] Initiate checking daily log file..."
if [ ! -e $dailyLog ]; then
	echo "[*] Createing daily log file.."
	touch $dailyLog
	touch $mountLog
else
	echo "  [+] Complete checking log file with no ploblem." 2>> $dailyLog	
fi
echo ""

# make malware dataCenter
echo "[INFO] Initiate checking malware IDC repository..." 2>> $dailyLog
if [ -d $shelterDir ]; then
        echo "  [*] Entering malware DataCenter.." 
	cd $shelterDir
	echo "  [+] Complete check malware IDC repository with no ploblem." 2>> $dailyLog
else
        echo "  [!] Malware DataCenter not founded !"
        echo "  [*] Create malware repo directory.."
        mkdir $shelterDir
        cd $shelterDir
        echo "  [+] Entering malware IDC repository complete."
        echo "  [*] Current location is, "$cur""
fi
echo ""



# Check disk for download shelter
echo "[INFO] Cheking download shelter repository.." 2>> $dailyLog
if [ ! mountpoint -q $shelterMountPoint ]; then
        echo "[ERROR] Download shelter not mounted !" 2>> $mountLog

        if [! mountpoint -q $shelterMountPoint ]; then
                echo "[CRITICAL] Download Shelter Mount fail !" 2>> $mountLog
                echo "  [!] Initiate auto unmount protocol" 2>> $mountLog
                umount -f $shelterMountPoint
        fi
else
        echo "  [+] Complete checking download shelter repotitory." 2>> $dailyLog
fi

# make daily malware dataCenter
if [ ! -d $dailyDir ]; then
        echo "[INFO] Entering daily malware DataCenter.." 2>> $dailyLog
        cur=$(pwd)
        echo "  [*] Current location is, $cur"
        echo ""
else
        echo "  [*] Create daily malware repo directory" 2>> $dailyLog
        mkdir $dailyDir
        cd $dailyDir
        echo ""
fi
echo ""
echo "+------------------------------------------------------+"
echo ""

# Check exist malware samples ..
#echo "[INFO] Searching malware file informations.." 2>> $dailyLog
#searchRes=$(find "$dailyDir" -name "$fName" -type f)
#echo "[INFO] Searching complete."  2>> $dailyLog

if [ -f $lfName ]; then
        echo "[INFO] daily malware sample has already exist!" 2>> $dailyLog
else
	echo "[INFO] Today's malware sample has not been downloaded yet"
        echo "  [!] Starting download daily malware samples.." 2>> $dailyLog
        echo ""
        # download daily malware samples
        reqDownload=$(wget -N https://datalake.abuse.ch/malware-bazaar/daily/"$daily_date".zip) >> $dailyLog
	#reqDownTemp=$(wget -N https://datalake.abuse.ch/malware-bazaar/daily/2023-01-29.zip)
fi


# inform download result
echo ""
echo ""
echo "#======================================================#"

if [ -e ]; then
        echo " [SUCCESS] Download malware sample complete." 2>> $dailyLog
        echo "     ->  file name : " $fName 2>> $dailyLog
        echo "     ->  direction : " $lfName 2>> $dailyLog
else
        echo " [ERROR] Failure download malware sample." 2>> $dailyLog
fi
echo "#======================================================#"
echo ""
echo ""
