#!/bin/bash
# clip_rasters.sh
# written by: Kimberly Peng
# Clips rasters for geographic and lambert azimuthal equal area geotiffs.

#Sample Usage
#/data4/afsisdata/IRI_MODIS/scripts/./clip_rasters.sh /data4/AfSIS2tifs/SRTM/SRTM_AfricaClip_LAEA /data4/afsisdata/IRI_MODIS/scripts/test 30000 laeaKPtemp trmm

ClipDir=$1 #directory containing clip masks
InputDir=$2 #directory containing geotiffs to be clipped
Resolution=$3 #resolution of the geotiffs
location=$4 #grass location in which the geotiffs will be imported and clipped
mapset=$5 #grass location in which the geotiffs will be imported and clipped

#####Start grass environment#####
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

#####Import clip file and set as mask#####
#change to the directory containing the clip file
cd $ClipDir

clipfile=$(ls *$Resolution*)
echo $clipfile
r.in.gdal input=$ClipDir/$clipfile output=$clipfile
r.mask -o input=$clipfile@"$mapset"
g.region rast=$clipfile@"$mapset"

#####Import geotiffs to clip#####
#change to directory containing the inputs to export
cd $InputDir

#creates a directory in the Input Directory to store the clipped layers
mkdir $InputDir/clipped
chmod -R 775 $InputDir/clipped

#loops through all the files in the Input Directory
for file in *.tif
do
	#imports files
	echo $file
	newName=$(echo $file | sed 's/.tif//')
	r.in.gdal input=$InputDir/$file output=$newName

	#export clipped file
	r.out.gdal input=$newName@"$mapset" output=$InputDir/clipped/"$newName"_clipped.tif
	chmod 775 $InputDir/clipped/"$newName"_clipped.tif
done