#!/bin/bash

# Global variable
shelterMountPoint=/mnt/malIDC_repository/
shelterDir=/mnt/malIDC_repository/malDataCenter/
DownloadDir=/mnt/malIDC_repository/malDataCenter/daily/
req_date=`date +%Y-%m-%d`
curDate=[$req_date]
fName="$daily_date".zip
lfName="$DownloadDir$fName"

rootPwd=$(pwd)
cd .. || return
logPwd=$(pwd)
cd $rootPwd || return

# general log variable
logDir=/log

dailyLogDir=$logPwd$logDir/daily/
daily_LogFileName="$curDate"_daily.log
dailyLog="$dailyLogDir$daily_LogFileName"

# Debug log variable
debugLogDir="$logPwd$logDir"/debug/
debug_LogFileName="$curDate"_debug.log
debugLog="$debugLogDir$debug_LogFileName"

# Mount log variable
mountLogDir="$logPwd$logDir"/mount/
mount_LogFileName="$curDate"_mount.log
mountLog="$mountLogDir$mount_LogFileName"


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

echo "$curDate[`date +%r`]  [INFO] Initiating malIDC protocol" 2>> "$dailyLog"
echo ""

echo "+------------------------------------------------------+"
echo ""


# Check & making environment
echo "[`date +%r`]  [INFO] Initiate checking environment..." 2>> "$dailyLog"
if [ ! -d "$logPwd" ]; then
        echo "  [!] log directory not founded !" 2>> "$dailyLog"
        echo "  [*] Create log directory.." 2>> "$dailyLog"
	# make log directory
        mkdir "$logPwd"

        echo "  [+] Complete create mother log directory" 2>> "$dailyLog"
else
        echo "  [+] Complete check environment with no ploblem." 2>> "$dailyLog"
fi
echo ""


echo "[`date +%r`]  [INFO] Initiate checking daily log file..." 2>> "$dailyLog"
# make daily log directory
if [ ! -d "$dailLogDir" ]; then
	# make daily log directory
        mkdir "$dailyLogDir" || echo " [`date +%r`] [INFO] Complete create daily log file" 2>> "$dailyLog"
else
	echo "[INFO] Daily log directory already exist!" && echo "  -> $dailyLogDir" 2>> "$dailyLog"
fi
touch $dailyLog

# make debug log directory
if [ ! -d "$debugLogDir" ]; then
	mkdir "$debugLogDir" || echo " [`date +%r`] [INFO] Complete create debug log directory" 2>> "$dailyLog"
else
	echo "[INFO] Debug log directory already exist!" && echo "  -> $debugLogDir" 2>> "$debugLog" 
fi
touch "$debugLog"

# make mount log directory
if [ ! -d "$mountLogDir" ]; then
	mkdir "$mountLogDir" || echo " [`date +%r`] [INFO] Complete create mount log directory" 2>> "$dailyLog"
else
	echo "[INFO] Mount log directory already exist!" echo "  -> $mountLogDir" 2>> "$debugLog"
fi
echo ""


# make malware dataCenter
echo "[`date +%r`]  [INFO] Initiate checking malware IDC repository..." 2>> "$dailyLog"
if [ -d "$shelterDir" ]; then
        echo "  [*] Entering malware DataCenter.." 2>> "$dailyLog"
	cd "$shelterDir" || return
	echo "  [+] Complete check malware IDC repository with no ploblem." >> "$dailyLog"
else
        echo "  [!] Malware DataCenter not founded !" 2>> "$dailyLog"
        echo "  [*] Create malware repo directory.." 2>> "$dailyLog"
        mkdir "$shelterDir"
        cd "$shelterDir" || return
        echo "  [+] Entering malware IDC repository complete." 2>> "$dailyLog"
	echo "  [*] Current location is  :  $(pwd)" 2>> "$dailyLog"
fi
echo ""



# Check disk for download shelter
echo "[`date +%r`]  [INFO] Cheking download shelter repository.." 2>> "$dailyLog"
if ! mountpoint -q "$shelterMountPoint"; then
	touch "$mountLog"
        echo "$curDate[`date +%r`] [ERROR] Download shelter not mounted !" 2>> "$mountLog"

        if !mountpoint -q "$shelterMountPoint"; then
                echo "[CRITICAL] Download Shelter Mount fail !" 2>> "$mountLog"
                echo "  [!] Initiate auto unmount protocol" 2>> "$mountLog"
                umount -f "$shelterMountPoint" || return
        fi
else
	echo "[`date +%r`] [INFO] Complete check download shelter disk." 2>> "$dailyLog"
fi

echo ""
echo "+------------------------------------------------------+"
echo ""
echo ""

# Check exist malware samples ..
#echo "[INFO] Searching malware file informations.." 2>> $dailyLog
#searchRes=$(find "$dailyDir" -name "$fName" -type f)
#echo "[INFO] Searching complete."  2>> $dailyLog


# make request file name
reqFileName=$(date +%Y-%m-%d --date '1 days ago').zip


if [ -f "$lfName" ]; then
        echo "[`date +%r`]  [INFO] daily malware sample has already exist!" 2>> "$dailyLog"
else
	echo "[`date +%r`]  [INFO] Today's malware sample has not been downloaded yet" 2>> "$dailyLog"
        echo "  [!] Starting download daily malware samples.." 2>> "$dailyLog"
        echo ""

	# move to malware sample shelter
	cd "$DownloadDir" || return

        # download daily malware samples
        reqDownload=$(wget -N https://datalake.abuse.ch/malware-bazaar/daily/"$reqFileName") >> "$dailyLog"

	# inform download result
	echo ""
	echo ""
	echo "#======================================================#"

	if [ -f "$lfName" ]; then
        	echo "[`date +%r`]  [SUCCESS] Download malware sample complete." 2>> "$dailyLog"
        	echo "     ->  file name : " "$fName" 2>> "$dailyLog"
        	echo "     ->  direction : " "$lfName" 2>> "$dailyLog"
	else
		echo "[[`date +%r`]  ERROR] Failure download malware sample." 2>> "$dailyLog"
	fi
	echo "#======================================================#"

fi
echo ""
echo ""
