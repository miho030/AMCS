#!/bin/bash


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
echo "             Malware sample download Selector           "
echo ""
echo "          Author : AOI (@jp_Rennka)      ver : v-0.0.2.1"
echo "#======================================================#"
echo ""
echo ""

echo "[`date +%r`]  [INFO] Initiating malIDC protocol"
echo ""

echo "+------------------------------------------------------+"
echo ""



echo "[INFO] you can download specify date of malware sample file."
echo "[INFO] Type the date time. ex)2023-01-03"


read -p "Enter the value : " strDate

if [ -z $strDate ]; then
	echo "[ERROR] invalid data type inserted."
	echo "   [INFO] type correct date type ex)2023-01-03"
	exit
else
	if [ $(expr length $strDate) != 10 ]; then
		echo "[ERROR] inserted data is out of range."
		echo "   [INFO] type correct date type ex)2023-01-03"
		exit
	else
		if [[ $strDate == *20* ]] && [[ $strDate == *-* ]]; then
			echo "   [+] confirmed. Your current value is, $strDate"
			echo ""


			echo "[INFO] where shoud you want download the sample file?"
			read -p "Enter the value (default: /mnt/malIDC_repository/malDataCenter/daily) : " strDownDir

			if [ ! -d $strDownDir]; then
                                echo "[ERROR] selected directory does not exist."
                                exit
                        else
                                if [ -z $strDownDir ]; then

					strDownDir=/mnt/malIDC_repository/malDataCenter/daily
					cd $strDownDir
                                else
                                        cd $strDownDir
                                fi

                                echo ""
				echo ""
                                reqDownload=$(wget -N https://datalake.abuse.ch/malware-bazaar/daily/"$strDate".zip)


				echo ""
 	                        echo ""
 	                        echo "#======================================================#"
                        	echo "[INFO] Successfully download malware sample file"
                        	echo "         -> file name : $strDate.zip"
                        	echo "         -> directory : $strDownDir"
                        	echo "#======================================================#"
                        	echo ""

                        fi

			echo "   [!] restart malIDC selector and insert correct data type."
		else
			echo "[ERROR] inserted data is not comparible."
			echo"   [INFO] type correct data type ex)2023-01-03"
		fi
	fi
fi
