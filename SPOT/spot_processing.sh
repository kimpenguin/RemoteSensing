#!/bin/bash
#spot_processing.sh
#script by Kimberly Peng
#date created: March 2015
#creates time series average, variance, standard deviation for fcover and fapar

#/data7/scripts/./spot_processing.sh /data7/M001335_FCOVER/Africa /data7/M001335_FCOVER/outputs fcover Geographic fcoverkP
#/data7/scripts/./spot_processing.sh /data7/M001334_FAPAR/Africa /data7/M001334_FAPAR/outputs fapar Geographic faparkP

#parameters given by the user are assigned to variables that will be used within the script
InputDir=$1
OutputDir=$2
DatasetName=$3
location=$4
mapset=$5

#######################STARTING THE GRASS ENVIRONMENT
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
mkdir /data3/grassdata/$location/$mapset
cp /data3/grassdata/$location/PERMANENT/WIND /data3/grassdata/$location/$mapset

# generate GRASS settings file:
# the file contains the GRASS variables which define the LOCATION etc.
echo "GISDBASE: /data3/grassdata
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
#g.gisenv -n

######
#changes location to the Input Directory
cd $InputDir

list=$(ls -d */)
# echo $list

for filedir in $list
do
	echo $filedir
	cd $InputDir/$filedir
	fileNam=$(ls *tiff)
	# echo $file
	newfileNam=$(echo $fileNam | sed "s/.tiff//")
	echo importing $newfileNam
	r.in.gdal -o input=$InputDir/$filedir$fileNam output=$newfileNam #bytes=4 north=40 south=-40 east=60 west=-20 rows=320 cols=320 anull=NaN 

	#will be used to store the name of each sum file
	strValue+="$newfileNam"@"$mapset"
	# echo $strValue

done
# set g.region to current file
g.region rast="$newfileNam"@"$mapset"

strFiles=$(echo $strValue | sed "s/@"$mapset"/@"$mapset",/g")
# echo $strFiles
comFiles=$(echo $strFiles | sed "s/.$//")
# echo $comFiles

#calculates time series average, variance, standard deviation
r.series input=$comFiles output="$DatasetName"_avg method=average
r.series input=$comFiles output="$DatasetName"_var method=variance
r.series input=$comFiles output="$DatasetName"_std method=stddev

# export average variance standard deviation into output directory
r.out.gdal input="$DatasetName"_avg@"$mapset" output=$OutputDir/"$DatasetName"_avg.tif
chmod 775 $OutputDir/"$DatasetName"_avg.tif
r.out.gdal input="$DatasetName"_var@"$mapset" output=$OutputDir/"$DatasetName"_var.tif
chmod 775 $OutputDir/"$DatasetName"_var.tif
r.out.gdal input="$DatasetName"_std@"$mapset" output=$OutputDir/"$DatasetName"_std.tif
chmod 775 $OutputDir/"$DatasetName"_std.tif

