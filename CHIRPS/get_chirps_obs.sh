#!/bin/bash
#get_chirps_obs.sh
#Written by: Kimberly Peng
#Created: January 2016
#This script creates a text file containing the number of CHIRPS observations for each year data was acquired.

#example command:
#/data2/CHIRPS/scripts/chirps_obs.sh /data2/CHIRPS/raws 1981 2015 geographic chirps

#Parameters
InputDir=$1
StartYear=$2
EndYear=$3
location=$4
mapset=$5

#creates a text file containing the year and the number of observations in that year.
cd $InputDir
d=$(date '+%Y%m%d-%H:%M:%S')
touch $InputDir/chirps_obs_$d.txt
y=$StartYear
while [ $y -le $EndYear ]
do
	# echo "Number of observations for" $y >> $InputDir/chirps_obs.txt
	cd $InputDir/$y
	tifList=$(ls *.tif)
	arr=($tifList)
	echo $y":"${#arr[@]} >> $InputDir/chirps_obs_$d.txt

	y=$((y+1))
done

# $ echo $var | sed 's/.*://'
#lists years and number of observations on the command line.
oldNum=0
for eachFile in $(cat $InputDir/chirps_obs_$d.txt); do
	echo oldNum is $oldNum
	curNum=$(echo $eachFile | sed 's/.*://')
	echo curNum is $curNum
	newVal=$((curNum+oldNum))
	oldNum=$newVal
done