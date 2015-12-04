#!/bin/bash

#/data2/GPM/scripts/get_file.sh /data2/GPM

InputDir=$1

cd $InputDir
#creates a list of all the geotiff inputs containing 1 and 0 values where 1 is precipitation
textlist=$(ls *_toDownload.txt)

for newFile in $(cat 2014_03_12_toDownload.txt); do
	if [ ${newFile:0:2} == "3B" ]; then
		echo $newFile
	fi
done