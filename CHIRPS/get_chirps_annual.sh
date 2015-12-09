#!/bin/bash

#/data2/CHIRPS/scripts/get_chirps_ts.sh /data2/CHIRPS/raws 1981 2015 geographic chirps

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

##### IMPORT AND ANNUAL
#change to the Input directory location
cd $InputDir

#create output directory
OutputDir=$InputDir/outputs
mkdir $OutputDir

y=$StartYear
while [ $y -le $EndYear ]
do
	echo Current Year $y
	cd $InputDir/$y
	tifList=$(ls *.tif)
	annualList="" #initalize list to store names of current year's observations
	for eachTif in $tifList
	do
		echo importing $eachTif
		newName=$(echo $eachTif | sed "s/.tif//")
		# echo $newName
		# import each file in date list
		r.in.gdal input=$InputDir/$y/$eachTif output=$newName
		r.null map="$newName"@"$mapset" setnull=-9999 

		#create a list of all year files
		annualList+=$eachTif" "

		#create a list of all files for time series average
		tsList+=$eachTif" "
	done
	# echo $annualList
	rsAnnualList=$(echo $annualList | sed "s/ /,/g;s/.tif/@"$mapset"/g")
	# echo $rsAnnualList
	#calculate export annual average
	r.series input=$rsAnnualList output=CHIRPS_"$y" method=average
	r.out.gdal input=CHIRPS_"$y"@"$mapset" output=$OutputDir/CHIRPS_"$y".tif
	chmod 775 $OutputDir/CHIRPS_"$y".tif

	y=$((y+1))
done
#####
##### TIME SERIES
# echo $tsList
rsTsList=$(echo $tsList | sed "s/ /,/g;s/.tif/@"$mapset"/g")
#calculate export annual average
r.series input=$rsTsList output=CHIRPS_"$StartYear"_"$EndYear" method=average
r.out.gdal input=CHIRPS_"$StartYear"_"$EndYear"@"$mapset" output=$OutputDir/CHIRPS_"$StartYear"_"$EndYear".tif
chmod 775 $OutputDir/CHIRPS_"$StartYear"_"$EndYear".tif

