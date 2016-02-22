#!/bin/bash
# get_gpm_ts.sh
# Written by Kimberly Peng
# Created 2015
#/data2/GPM/scripts/./get_gpm_ts.sh /data2/GPM 2014 2015 geographic GPM

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

g.region n=40 s=-40 e=60 w=-20 res=0.1
#g.gisenv -n
#####

#####IMPORT DATA INTO GRASS
cd $InputDir
datelist=$(ls 2*.txt)
RawDir=$InputDir/raws
cd $RawDir
SumDir=$InputDir/avg
mkdir $SumDir
#loop through each date
for d in $datelist
do
	fileDate=${d:0:8}
	dlist=$(ls 3B-HHR-*"$fileDate"*.tif) #creates a list of all files for specific date
	# echo $tiflist

	for dFile in $dlist
	do
		# echo $dFile
		newName=$(echo $dFile | sed "s/.V03D.tif//")
		# echo $newName
		# import each file in date list
		echo r.in.gdal -o input=$RawDir/$dFile output=$newName
		# g.region rast="$newName"@"$mapset"
		echo r.null map="$newName"@"$mapset" setnull=9999
		echo r.null map="$newName"@"$mapset" setnull=0
	done
	rsList=$(echo $dlist | sed "s/ /,/g;s/.V03D.tif/@"$mapset"/g")
	# echo $rsList
	echo r.series input=$rsList output=GPM_IMERG_"$fileDate" method=average
	echo r.out.gdal input=GPM_IMERG_"$fileDate"@"$mapset" output=$SumDir/GPM_IMERG_"$fileDate".tif
	echo chmod 775 $SumDir/GPM_IMERG_"$fileDate".tif
done
#####CREATE TIME Series
# OutputDir=$InputDir/output
# mkdir $OutputDir
# cd $SumDir
# sumlist=$(ls GPM*.tif)
# echo $sumlist

# rsSumList=$(echo $sumlist | sed "s/ /,/g;s/.tif/@"$mapset"/g")
# echo $rsSumList
# g.remove rast=GPM_IMERG_"$StartYear"_"$EndYear"@"$mapset"
# r.series input=$rsSumList output=GPM_IMERG_"$StartYear"_"$EndYear" method=average
# r.out.gdal input=GPM_IMERG_"$StartYear"_"$EndYear"@"$mapset" output=$OutputDir/GPM_IMERG_"$StartYear"_"$EndYear".tif
# chmod 775 $OutputDir/GPM_IMERG_"$StartYear"_"$EndYear".tif


