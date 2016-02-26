#!/bin/bash
#This script creates a text file containing the number of raw files for each year. 
#To be used to update the time series data products
#/data4/afsisdata/USGS_updates/scripts/albedo_obs.sh /data1/afsisdata/MODIS/Albedo_MCD43A3/Albedo_BSA_vis/geotiffs 2000 2015

#Parameters
InputDir=$1
StartYear=$2
EndYear=$3

OutputDir=$InputDir/tracker
mkdir $OutputDir

#create a text file containing the total number of albedo raw files for each year
cd $InputDir
d=$(date '+%Y%m%d-%H:%M:%S')
touch $OutputDir/albedo_obs_$d.txt
y=$StartYear
while [ $y -le $EndYear ]
do
	# echo "Number of observations for" $y >> $OutputDir/chirps_obs.txt
	# cd $OutputDir/$y
	tifList=$(ls $y*.tif)
	arr=($tifList)
	echo $y":"${#arr[@]} >> $OutputDir/albedo_obs_$d.txt
	echo ${arr[@]} >> $OutputDir/albedo_files_$d.txt
	y=$((y+1))
done

#create a total number of observations
oldNum=0
for eachFile in $(cat $OutputDir/albedo_obs_$d.txt); do
	echo oldNum is $oldNum
	curNum=$(echo $eachFile | sed 's/.*://')
	echo curNum is $curNum
	newVal=$((curNum+oldNum))
	oldNum=$newVal
done