#!/bin/bash
#get_chirps_monthly.sh
#Written by: Kimberly Peng
#Date: December 2015
#This script creates a monthly average of the CHIRPS data for the specified temporal range.

#example command:
#/data2/CHIRPS/scripts/./get_chirps_monthlyv2.sh /data2/CHIRPS/raws 1981 1982 geographic chirps

#Parameters
InputDir=$1
StartYear=$2
EndYear=$3
location=$4
mapset=$5

######STARTING THE GRASS ENVIRONMENT
#This section was derived from Bash examples (GNU/Linux) on http://grasswiki.osgeo.org/wiki/Working_with_GRASS_without_starting_it_explicitly
#to start the grass environment without starting a GRASS session

#some settings:
TMPDIR=/tmp

# directory of our software and grassdata:
#MAINDIR=/
# our private /usr/ directory:
#MYUSER=$MAINDIR/Users/username/

# path to GRASS binaries and libraries:
export GISBASE=/usr/lib/grass64

#Create temporary mapset with WIND parameter
mkdir /data2/grassdata/$location/$mapset
cp /data2/grassdata/$location/PERMANENT/WIND /data2/grassdata/$location/$mapset

# generate GRASS settings file:
# the file contains the GRASS variables which define the LOCATION etc.
echo "GISDBASE: /data2/grassdata
LOCATION_NAME: $location
MAPSET: $mapset
" > $TMPDIR/.grassrc6_modis$$

# path to GRASS settings file:
export GISRC=$TMPDIR/.grassrc6_modis$$

# first our GRASS, then the rest
export PATH=$GISBASE/bin:$GISBASE/scripts:$PATH
#first have our private libraries:
export LD_LIBRARY_PATH=$GISBASE/lib:$LD_LIBRARY_PATH

# use process ID (PID) as lock file number:
export GIS_LOCK=$$

# this should print the GRASS version used:
g.version 
g.region n=40 s=-40 e=60 w=-20 res=0.05
#####

#####PROCESS MONTHLY AVERAGES
#create output directory
OutputDir=$InputDir/outputs
mkdir $OutputDir
months="01 02 03 04 05 06 07 08 09 10 11 12"

#loop through the months
for eachMonth in $months
do
	echo current month is $eachMonth
	monthList=""
	tsList=""
	y=$StartYear
	incrementalNum=0
	while [ $y -le $EndYear ]
	do
		echo Current Year $y
		cd $InputDir/$y
		# tifList=$(ls *.tif)
		inputList=$(ls | grep "^chirps...........$eachMonth")
		# echo $inputList
		arr=($inputList)
		obs=${#arr[@]}
		monthList=""
		for eachTif in $inputList
		do
			# import each file in date list
			echo importing $eachTif
			newName=$(echo $eachTif | sed "s/.tif//")
			r.in.gdal input=$InputDir/$y/$eachTif output=$newName
			r.null map="$newName"@"$mapset" setnull=-9999 
			monthList+=$eachTif" "
		done

		sumList=$(echo $monthList | sed "s/ /,/g;s/.tif/@"$mapset"/g")
		# r.series input=$sumList output=CHIRPS_sum_"$y"_"$eachMonth" method=sum

		#add name to time series list
		tsList+=CHIRPS_sum_"$y"_"$eachMonth"" "

		# remove monthly rasters from mapset
		# g.remove rast=$sumList

		#increment number of observations
		newVal=$((obs+incrementalNum))
		incrementalNum=$newVal

		y=$((y+1))
	done
	
	#total number of observations for that month
	echo total number of observations is $incrementalNum

	rsTSList=$(echo $tsList | sed "s/ / @"$mapset"/g")
	# rsTSList=$(echo $tsList | sed "s/ /,/g")
	echo new name is $rsTSList
	# #creates a sum of all the years
	r.series input=$rsTSList output=CHIRPS_sum_"$StartYear"_"$EndYear"_"$eachMonth" method=sum

	# #calculates average
	r.mapcalculator amap=CHIRPS_sum_"$StartYear"_"$EndYear"_"$eachMonth" formula="A/$incrementalNum" outfile=CHIRPS_avg_"$StartYear"_"$EndYear"_"$eachMonth"
	r.out.gdal input=CHIRPS_avg_"$StartYear"_"$EndYear"_"$eachMonth"@"$mapset" output=$OutputDir/CHIRPS_avg_"$StartYear"_"$EndYear"_"$eachMonth".tif
	chmod 775 $OutputDir/CHIRPS_avg_"$StartYear"_"$EndYear"_"$eachMonth".tif

done

