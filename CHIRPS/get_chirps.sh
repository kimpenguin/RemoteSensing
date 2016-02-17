#!/bin/bash
#get_chirps.sh
#Written by: Kimberly Peng
#Date: November 2015
#This script downloads the CHIRPS 0.05 degree raw observations for Africa.
#The raw zip files are extracted, leaving geotiff files of the raw observations.
#/data2/CHIRPS/scripts/get_chirps.sh /data2/CHIRPS 1981 2015 geographic chirps

#Parameters
InputDir=$1
StartYear=$2
EndYear=$3
location=$4
mapset=$5

#change to the Input directory location
cd $InputDir
#create directory to store raw data
RawDir=$InputDir/raws
mkdir $RawDir

#####DOWNLOAD DATA
year=$StartYear
while [ $((year)) -le $((EndYear)) ]
do
	echo Start Year is $year
	yearDir=$RawDir/$year
	mkdir $yearDir

	#get listing of tifs in the year's directory
	echo getting ftp://chg-ftpout.geog.ucsb.edu/pub/org/chg/products/CHIRPS-2.0/africa_daily/tifs/p05/$year/
	curl ftp://chg-ftpout.geog.ucsb.edu/pub/org/chg/products/CHIRPS-2.0/africa_daily/tifs/p05/$year/ > $yearDir/observations.txt
	for dFile in $(cat $yearDir/observations.txt); do
		if [ ${dFile:0:6} == "chirps" ]; then
			echo downloading $dFile into $yearDir
			curl ftp://chg-ftpout.geog.ucsb.edu/pub/org/chg/products/CHIRPS-2.0/africa_daily/tifs/p05/$year/$dFile -o $yearDir/$dFile
		fi
	done
	#extract zip files
	cd $yearDir
	gzip -d *.gz

	year=$((year+1))
done