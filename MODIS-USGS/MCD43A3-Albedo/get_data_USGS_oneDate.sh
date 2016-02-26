#!/bin/bash
#get_data_USGS_onedate.sh
#This script was modified to allow users the ability to specify one specific date to download
#written by Kimberly Peng
#modified version of get_data_USGS.sh written by Sonya Ahamed

#Sample command
#/data4/afsisdata/USGS_updates/scripts/get_data_USGS_oneDate.sh /data4/afsisdata/USGS_updates/albedo/redoDate MOLT MOD15A2.005 2013.12.27
#/data4/afsisdata/USGS_updates/scripts/get_data_USGS_oneDate.sh /data4/afsisdata/USGS_updates/scripts/test MOTA MCD43A3.005 2013.12.27

#Parameters
InputDir=$1
basePath=$2
baseDir=$3
oneDate=$4

echo data is $oneDate



#change to the Input directory location
cd $InputDir
#creates a base directory and changes location to the base directory
mkdir $baseDir
cd $baseDir

#make a date directory to store the raw files
mkdir $oneDate
cd $oneDate

#Declare tiles to download in variable tileList
tileList=(h16v06 h16v07 h16v08 h17v05 h17v06 h17v07 h17v08 h18v05 h18v06 h18v07 h18v08 h18v09 h19v05 h19v06 h19v07 h19v08 h19v09 h19v10 h19v11 h19v12 h20v05 h20v06 h20v07 h20v08 h20v09 h20v10 h20v11 h20v12 h21v06 h21v07 h21v08 h21v09 h21v10 h21v11 h22v07 h22v08 h22v09 h22v10 h22v11 h23v07 h23v08)

#Captures a listing of all the files that are located in the current date directory
curl http://e4ftl01.cr.usgs.gov/$basePath/$baseDir/$oneDate/ --user anonymous: > allFiles4Date.txt
echo http://e4ftl01.cr.usgs.gov/$basePath/$baseDir/$oneDate

#From all the files only get the *.hdf and *.hdf.xml files
grep hdf allFiles4Date.txt > files2Get.txt
	
#downloads only the relevant tiles
totFile=0
for eachTile in ${tileList[*]}
do
	echo $eachTile #Get only the tiles needed 
	grep $eachTile files2Get.txt > tiles2Get.txt
	numFiles=$(cat tiles2Get.txt | wc -l)
	totFile=$(($totFile+$numFiles))

	#creates and array containing the names of the files to be downloaded
	for newWord2 in $(cat tiles2Get.txt); do
		if [ ${newWord2:0:4} == "href" ]; then
			eachFile=$(echo ${newWord2} | sed 's/.*"\(.*\)"[^"]*$/\1/')
			#downloads file from USGS
			curl --retry 10 -O http://e4ftl01.cr.usgs.gov/$basePath/$baseDir/$oneDate/$eachFile --user anonymous:
	        #echo http://e4ftl01.cr.usgs.gov/$basePath/$baseDir/$oneDate/$eachFile
			#generates error report if the file fails to download
			if [ $? -ne 0 ]; then
				echo $basePath/$baseDir/$eachDate/$eachFile "failed error code "$? >> downloadErr.txt
       		fi
		fi
	done
done

echo total number $totFile
echo $eachDate $totFile >> $InputDir/totalObs.txt

