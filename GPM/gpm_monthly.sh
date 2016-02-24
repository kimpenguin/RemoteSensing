#!/bin/bash
# get_gpm_monthly.sh
# Written by Kimberly Peng
# Created 2015
#creates a monthly average of the GPM data

#/data2/GPM/scripts/./gpm_monthly.sh /data2/GPM 2014 2015 geographic GPM

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

g.region n=40 s=-40 e=60 w=-20
#g.gisenv -n
#####

#####IMPORT DATA INTO GRASS
#change to the Input directory location
cd $InputDir
#create directory to store raw data
RawDir=$InputDir/raws
# mkdir $RawDir

#create directory to house the average for each day observation
RawMod=$InputDir/raws_modified
mkdir $RawMod

#get a listing of download text files
datelist=$(ls $InputDir/toDownload/2*.txt)
# echo $datelist

cd $RawDir
#loop through each date
for d in $datelist
do
	echo $d
	# fileDate=${d:0:8}
	fileDate=${d:22:8}
	echo $fileDate
	dlist=$(ls 3B-HHR-*"$fileDate"*.tif) #creates a list of all files for specific date
	echo $dlist

	for dFile in $dlist
	do
		# echo $dFile
		newName=$(echo $dFile | sed "s/.V03D.tif//")
		# echo $newName
		# import each file in date list
		r.in.gdal -o input=$RawDir/$dFile output=$newName
		# g.region rast="$newName"@"$mapset"
		r.null map="$newName"@"$mapset" setnull=9999
		r.null map="$newName"@"$mapset" setnull=0
	done
	rsList=$(echo $dlist | sed "s/ /,/g;s/.V03D.tif/@"$mapset"/g")
	# echo $rsList
	#create a daily average of precipitation from the hourly observations
	r.series input=$rsList output=GPM_IMERG_"$fileDate" method=average
	r.out.gdal input=GPM_IMERG_"$fileDate"@"$mapset" output=$RawMod/GPM_IMERG_"$fileDate".tif
	chmod 775 $RawMod/GPM_IMERG_"$fileDate".tif
done


##### Create Monthly Averages
#change to the Input directory location
cd $RawMod
#create directory to store final outputs
OutputDir=$InputDir/output
mkdir $OutputDir

months="01 02 03 04 05 06 07 08 09 10 11 12"

#loop through months to create average for each
for eachMonth in $months
do
	echo current month is $eachMonth
	#creates a list for each month
	monList=$(ls | grep "^GPM_IMERG_....$eachMonth")
	rsList=$(echo $monList | sed "s/ /,/g;s/.tif/@"$mapset"/g")
	echo $rsList

	# echo $monList
	for eachFile in $monList
	do
		echo $eachFile
		newName=$(echo $eachFile | sed "s/.tif//")
		echo $newName
		r.in.gdal -o input=$RawMod/$eachFile output=$newName
		g.region rast="$newName"@"$mapset"
	done
	#calculate average and export
	r.series input=$rsList output=GPM_IMERG_avg_"$StartYear"_"$EndYear"_"$eachMonth" method=average
	r.out.gdal input=GPM_IMERG_avg_"$StartYear"_"$EndYear"_"$eachMonth"@"$mapset" output=$OutputDir/GPM_IMERG_avg_"$StartYear"_"$EndYear"_"$eachMonth".tif
	chmod 775 $OutputDir/GPM_IMERG_avg_"$StartYear"_"$EndYear"_"$eachMonth".tif

	#clean mapset
	g.remove rast=$rsList
done

