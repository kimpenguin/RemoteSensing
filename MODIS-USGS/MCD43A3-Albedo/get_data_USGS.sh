#!/bin/bash
#get_data_USGS.sh
#This script downloads all the available MODIS observations 
#written by Sonya Ahamed
#modified by Kimberly Peng

#Sample command
#/data4/afsisdata/USGS_updates/scripts/get_data_USGS.sh /data4/afsisdata/USGS_updates/albedo MOTA MCD43A3.005

#Parameters
InputDir=$1
basePath=$2
baseDir=$3

#change to the Input directory location
cd $InputDir

#Declare tiles to download in variable tileList
tileList=(h16v06 h16v07 h16v08 h17v05 h17v06 h17v07 h17v08 h18v05 h18v06 h18v07 h18v08 h18v09 h19v05 h19v06 h19v07 h19v08 h19v09 h19v10 h19v11 h19v12 h20v05 h20v06 h20v07 h20v08 h20v09 h20v10 h20v11 h20v12 h21v06 h21v07 h21v08 h21v09 h21v10 h21v11 h22v07 h22v08 h22v09 h22v10 h22v11 h23v07 h23v08)

#creates a base directory and changes location tot he base directory
mkdir $baseDir
cd $baseDir

#Determine the directory dates for $baseDir
curl http://e4ftl01.cr.usgs.gov/$basePath/$baseDir/ --user anonymous: > dirDates.txt

#creates an array containing a cleaned up version of all the dates
i=1
for newWord in $(cat $InputDir/$baseDir/dirDates.txt); do
	if [ ${newWord:0:4} == "href" ]; then
		case ${newWord:6:1} in
		[0-9]* )
			result=1
			;;
		* )
			result=0
			;;
		esac
		if [ $result -eq 1 ] ; then
			newWords[$i]=${newWord:6:10}
			i=$((i+1))
		fi 
	fi
done
numDates=${#newWords[@]}
echo number of dates is $numDates

#Process each date in the $baseDir
n=1
while [ $n -le $numDates ]
#while [ $n -le 1 ]
do
	#returns to $baseDir	
	cd $InputDir/$baseDir

	eachDate=${newWords[$n]}
	#creates a directory for the current date and then moves into date directory
	mkdir -m 775 $eachDate
	cd $eachDate

	#Captures a listing of all the files that are located in the current date directory
	curl http://e4ftl01.cr.usgs.gov/$basePath/$baseDir/$eachDate/ --user anonymous: > allFiles4Date.txt
	echo http://e4ftl01.cr.usgs.gov/$basePath/$baseDir/$eachDate

	#From all the files only get the *.hdf and *.hdf.xml files
       grep hdf allFiles4Date.txt > files2Get.txt

	#downloads only the relevant tiles
	for eachTile in ${tileList[*]}
	do
		echo $eachTile #Get only the tiles needed 
		grep $eachTile files2Get.txt > tiles2Get.txt
		
		#creates and array containing the names of the files to be downloaded
		g=1
		for newWord2 in $(cat tiles2Get.txt); do
			if [ ${newWord2:0:4} == "href" ]; then
				newWords2[$g]=$(echo ${newWord2} | sed 's/.*"\(.*\)"[^"]*$/\1/')
				eachFile=${newWords2[$g]}
				#downloads file from USGS
				curl --retry 10 -O http://e4ftl01.cr.usgs.gov/$basePath/$baseDir/$eachDate/$eachFile --user anonymous:
		              
				#generates error report if the file fails to download
				if [ $? -ne 0 ]; then
					echo $basePath/$baseDir/$eachDate/$eachFile "failed error code "$? >> downloadErr.txt
                 		fi

				g=$((g+1))
			fi
		done
        done


	#increments for the next date
	n=$((n+1))
	
done

echo ARRAY IS ${newWords2[@]}
