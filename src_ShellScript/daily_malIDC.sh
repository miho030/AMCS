#!/bin/bash

#software Information
author="github.com/miho030"
sfVersion="0.2.0"

# Global variable
curYear=`date +%Y`
req_date=`date +%Y-%m-%d`

shelterMountPoint=/mnt/malIDC_repository/
shelterDir=/mnt/malIDC_repository/malDataCenter/
downloadDir=$shelterDir$curYear/

curDate=[$req_date]
fName="$daily_date".zip
lfName="$downloadDir$fName"

rootPwd=$(pwd)
cd .. || return
logPwd=$(pwd)
cd $rootPwd || return

# General log variable
logDir=/log

dailyLogDir=$logPwd$logDir/daily/
daily_LogFileName="$curDate"_daily.log
dailyLog="$dailyLogDir$daily_LogFileName"

# Mount log variable
mountLogDir="$logPwd$logDir"/mount/
mount_LogFileName="$curDate"_mount.log
mountLog="$mountLogDir$mount_LogFileName"


malIDC_interface()
{
	echo "" && echo ""
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
	echo "        Author : $author      ver : $sfVersion"
	echo "#======================================================#"
	echo "" && echo ""
	echo ""
	echo "$curDate[`date +%r`]  [INFO] Initiating malIDC protocol" 2>> "$dailyLog"
}



checkDir()
{
	echo "" && echo "+----------------------------------------------------------+" && echo ""

	# Check & making environment
	echo "[`date +%r`]  [INFO] Initiate checking log environment..." 2>> "$dailyLog"
	if [ ! -d "$logPwd" ]; then
		echo "  [!] Mother log directory not founded ! --> Create log directory.." 2>> "$dailyLog"
		mkdir "$logPwd"
		echo "  [`date +%r`] [INFO] Complete create mother log directory" 2>> "$dailyLog"
	else
		echo "  [+] Complete check log environment with no ploblem." 2>> "$dailyLog"
	fi
	echo ""

	# Check & making daily log dir
	echo "[`date +%r`]  [INFO] Initiate checking daily log dir/file..." 2>> "$dailyLog"
	if [ ! -d "$dailyLogDir" ]; then
		echo "  [!] daily log directory not founded ! --> Create log directory.." 2>> "$dailyLog"
		mkdir "$dailyLogDir" && touch $dailyLog
		echo "  [`date +%r`] [INFO] Complete create daily log file" 2>> "$dailyLog"
	else
		echo "  [+] Complete check daily log directory with no ploblem." 2>> "$dailyLog"
	fi
	echo ""

	# make mount log directory
	echo "[`date +%r`]  [INFO] Initiate checking mount log dir/file..." 2>> "$dailyLog"
	if [ ! -d "$mountLogDir" ]; then
		echo "  [!] mount log directory not founded ! --> Create log directory.." 2>> "$dailyLog"
		mkdir "$mountLogDir" && touch $mountLog
		echo "  [`date +%r`] [INFO] Complete create mount log directory" 2>> "$dailyLog"
	else
		echo "  [+] Complete check mount log directory with no ploblem." 2>> "$dailyLog"
	fi

	echo "" && echo "+----------------------------------------------------------+" && echo ""
}



makeStorage()
{
	# make malware dataCenter
	echo "[`date +%r`]  [INFO] Initiate checking malware IDC repository..." 2>> "$dailyLog"
	if [ -d "$shelterDir" ]; then
		cd "$shelterDir" || return
		echo "  [+] Complete check malware IDC repository with no ploblem." >> "$dailyLog"
	else
		echo "  [!] Malware DataCenter not founded !  --> Create malware repo directory.." 2>> "$dailyLog"
		mkdir "$shelterDir"
		cd "$shelterDir" || return

		echo "  [+] Entering malware IDC repository complete." 2>> "$dailyLog"
		echo "  [*] Current location is  :  $(pwd)" 2>> "$dailyLog"
	fi
	echo ""

	# make download Directory
	[ ! -d "$downloadDir" ] && mkdir $downloadDir

}

checkMountSys()
{
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

	echo "" && echo "+------------------------------------------------------+" && echo ""

	# Check exist malware samples ..
	#echo "[INFO] Searching malware file informations.." 2>> $dailyLog
	#searchRes=$(find "$dailyDir" -name "$fName" -type f)
	#echo "[INFO] Searching complete."  2>> $dailyLog
}


startDownloadMal()
{
	# make request file name
	reqFileName=$(date +%Y-%m-%d --date '1 days ago').zip

	if [ -f "$lfName" ]; then
		echo "[`date +%r`]  [INFO] daily malware sample has already exist!" 2>> "$dailyLog"
	else
		echo "[`date +%r`]  [INFO] Today's malware sample has not been downloaded yet" 2>> "$dailyLog"
		echo "  [!] Starting download daily malware samples.." 2>> "$dailyLog" && echo ""

		cd "$downloadDir" || return # move to malware sample shelter
		# download daily malware samples
		reqDownload=$(wget -N https://datalake.abuse.ch/malware-bazaar/daily/"$reqFileName") >> "$dailyLog"


		# inform download result
		echo "" && echo ""
		if [ -e "$downloadDir$reqFileName" ]; then
			echo "#======================================================#" 2>> "$dailyLog"
			echo "[`date +%r`]  [SUCCESS] Download malware sample complete." 2>> "$dailyLog"
			echo "     ->  file name : $fName" 2>> "$dailyLog"
			echo "     ->  direction : $lfName" 2>> "$dailyLog"
			echo "#======================================================#" 2>> "$dailyLog"
		else
			echo "#======================================================#" 2>> "$dailyLog"
			echo "[[`date +%r`]  ERROR] Failure download malware sample." 2>> "$dailyLog"
			echo "#======================================================#" 2>> "$dailyLog"
		fi
	fi
}
echo ""
echo ""



malIDC_interface
checkDir
makeStorage
checkMountSys
startDownloadMal
