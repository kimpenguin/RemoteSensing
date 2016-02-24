#!/bin/bash
# get_gpm.sh
# downloads the raw GPM data
# Written by Kimberly Peng
# Created 2015
#/data2/GPM/scripts/./get_gpm.sh /data2/GPM 2014 2015

#Parameters
InputDir=$1
StartYear=$2
EndYear=$3


#change to the Input directory location
cd $InputDir
#create directory to store raw data
RawDir=$InputDir/raws
mkdir $RawDir

#create directory to contain text files with download files
ToDownload=$InputDir/toDownload
mkdir $ToDownload
#####DOWNLOAD DATA
#gets a list of directories
curl ftp://arthurhou.pps.eosdis.nasa.gov/gpmdata/ --user kmp2143@columbia.edu:kmp2143@columbia.edu > dirDates.txt

months="01 02 03 04 05 06 07 08 09 10 11 12"
days="01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31"

year=$StartYear
while [ $((year)) -le $((EndYear)) ]
do
	echo Start Year is $year
	i=1
	for newWord in $(cat dirDates.txt); do
		if [ $((i%9)) -eq 0 ] && [ ${newWord:0:4} == $year ]; then
			echo year is $newWord
			curl ftp://arthurhou.pps.eosdis.nasa.gov/gpmdata/$newWord/ --user kmp2143@columbia.edu:kmp2143@columbia.edu > dirDates_"$newWord".txt
			for eachMonth in $months
			do
				echo month is $eachMonth
				for eachDay in $days
				do
					echo day is $eachDay
					echo "$newWord""$eachMonth""$eachDay"_toDownload.txt
					echo ftp://arthurhou.pps.eosdis.nasa.gov/gpmdata/"$newWord"/"$eachMonth"/"$eachDay"/
					curl ftp://arthurhou.pps.eosdis.nasa.gov/gpmdata/"$newWord"/"$eachMonth"/"$eachDay"/gis/ --user kmp2143@columbia.edu:kmp2143@columbia.edu > "$ToDownload"/"$newWord""$eachMonth""$eachDay"_toDownload.txt
					# loop through text file to download the tifs
					for newFile in $(cat "$ToDownload"/"$newWord""$eachMonth""$eachDay"_toDownload.txt); do
						if [ ${newFile:0:2} == "3B" ]; then
							echo ftp://arthurhou.pps.eosdis.nasa.gov/gpmdata/"$newWord"/"$eachMonth"/"$eachDay"/gis/"$newFile"
							curl ftp://arthurhou.pps.eosdis.nasa.gov/gpmdata/"$newWord"/"$eachMonth"/"$eachDay"/gis/"$newFile" --user kmp2143@columbia.edu:kmp2143@columbia.edu -o $RawDir/$newFile
						fi
					done
				done
			done

		fi
			i=$((i+1))
	done
	year=$((year+1))
done
####