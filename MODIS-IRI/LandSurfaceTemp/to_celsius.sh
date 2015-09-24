#!/bin/bash
# to_celsius.sh
# written by: Kimberly Peng
# This script converts Kelvin values to celsius

#Input parameters: 
# /data4/afsisdata/IRI_MODIS/scripts/./geotiff_scale_clip.sh /data4/afsisdata/IRI_MODIS/Time_Series/200002_201503/laea /data4/afsisdata/IRI_MODIS/Time_Series/200002_201503/laea/clipped laeaKPtemp modis201503v2

#bash scriptname.sh InputDirectory OutputDirectory DatasetName GrassLocation mapset Resolution ScaleFactor FileType
InputDir=$1
OutputDir=$2
location=$3
mapset=$4

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

#####Import Raster and convert to celsius#####
cd $InputDir
# contains a list of all files in input directory
list=$(ls *.tif)
echo $list

time for file in ${list[*]}
do 
	echo $file
	file0=${file/\.tif/}  #take out the .tif from name
	name=$(echo $file | cut -d _ -f 1)
	echo $name

	echo Importing files into GRASS
	r.in.gdal -e input=$InputDir/$file output=$file0

	#celsius conversion
	r.mapcalculator formula="$file0"-273.15 outfile="$file0"_celsius

	#exporting the celsius file
	r.out.gdal input="$file0"_celsius type=Float32 output=$OutputDir/"$file0"_celsius.tif 
	chmod 775 $OutputDir/"$file0"_celsius.tif
done
