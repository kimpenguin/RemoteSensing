#!/bin/bash
#get_chirps_monthly.sh
#Written by: Kimberly Peng
#Date: December 2015
#This script creates a monthly average of the CHIRPS data for the specified temporal range.

#example command:
#/data2/CHIRPS/scripts/./get_chirps_monthly.sh /data2/CHIRPS/raws 1981 2015 geographic chirps

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
	y=$StartYear
	while [ $y -le $EndYear ]
	do
		echo Current Year $y
		cd $InputDir/$y
		# tifList=$(ls *.tif)
		inputList=$(ls | grep "^chirps...........$eachMonth")
		# echo $inputList

		for eachTif in $inputList
		do
			# import each file in date list
			echo importing $eachTif
			newName=$(echo $eachTif | sed "s/.tif//")
			r.in.gdal input=$InputDir/$y/$eachTif output=$newName
			r.null map="$newName"@"$mapset" setnull=-9999 
			monthList+=$eachTif" "
		done
		
		y=$((y+1))
	done
	# echo $monthList
	rsMonthList=$(echo $monthList | sed "s/ /,/g;s/.tif/@"$mapset"/g")
	echo $rsMonthList
	#calculate export monthly average and export geotiff
	r.series input=$rsMonthList output=CHIRPS_"$StartYear"_"$EndYear"_"$eachMonth" method=average
	r.out.gdal input=CHIRPS_"$StartYear"_"$EndYear"_"$eachMonth"@"$mapset" output=$OutputDir/CHIRPS_"$StartYear"_"$EndYear"_"$eachMonth".tif
	chmod 775 $OutputDir/CHIRPS_"$StartYear"_"$EndYear"_"$eachMonth".tif

	# remove monthly rasters from mapset
	g.remove rast=$rsMonthList
done