#!/bin/bash
#albedo_geoprocessing.sh
## This script calculates average, standard deviation, and variance in GRASS GIS for the MODIS Albedo data product.
#Written by Sonya Ahamed, modified by Kimberly Peng
#Last modified: 2015

#Sample Command: 
#/data4/afsisdata/USGS_updates/scripts/./albedo_geoprocessing.sh /data2/afsisdata/MODIS/Albedo_WSA_shortwave/geotiffs WSA_shortwave sinusoidalSA kpeng

InputDir=$1
DatasetName=$2
location=$3
mapset=$4

#create output directory for time series files
OutputDir=$InputDir/outputs
mkdir $OutputDir

echo $location
############Start grass environment

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

####################################################################

cd $InputDir
list=$(ls *$DatasetName*)
len=$(ls -1 *$DatasetName*| wc )    #swap in count of total number of grids

echo $list
####################################################################
#specify g.region 
g.region n=4447802.07792318 s=-4447802.07941082 w=-2223901.03900373 e=8709352.44561959 rows=19200 cols=23598

#Import grids into grass as a loop for all the grids in a directory
time for file in ${list[*]}
do
   echo $file
   r.in.gdal input=$InputDir/$file output=${file/\.tif/} -e  #take out the .tif from name
   g.region rast=${file/\.tif/}@$mapset
   r.null map=${file/\.tif/}@$mapset setnull=32767 
done

#black sky albedo
if [ $DatasetName == "BSA_vis" ] ; then
	r.series input="`g.mlist pattern='*BSA_vis' sep=,`" output=$DatasetName'Average@'$mapset method=average
	r.series input="`g.mlist pattern='*BSA_vis' sep=,`" output=$DatasetName'Variance@'$mapset method=variance
	r.series input="`g.mlist pattern='*BSA_vis' sep=,`" output=$DatasetName'StdDev@'$mapset method=stddev
elif [ $DatasetName == "BSA_nir" ]; then
	r.series input="`g.mlist pattern='*BSA_nir' sep=,`" output=$DatasetName'Average@'$mapset method=average
	r.series input="`g.mlist pattern='*BSA_nir' sep=,`" output=$DatasetName'Variance@'$mapset method=variance
	r.series input="`g.mlist pattern='*BSA_nir' sep=,`" output=$DatasetName'StdDev@'$mapset method=stddev
elif [ $DatasetName == "BSA_shortwave" ]; then
	r.series input="`g.mlist pattern='*BSA_shortwave' sep=,`" output=$DatasetName'Average@'$mapset method=average
	r.series input="`g.mlist pattern='*BSA_shortwave' sep=,`" output=$DatasetName'Variance@'$mapset method=variance
	r.series input="`g.mlist pattern='*BSA_shortwave' sep=,`" output=$DatasetName'StdDev@'$mapset method=stddev
# white sky albedo
elif [ $DatasetName == "WSA_vis" ] ; then 
	r.series input="`g.mlist pattern='*WSA_vis' sep=,`" output=$DatasetName'Average@'$mapset method=average
	r.series input="`g.mlist pattern='*WSA_vis' sep=,`" output=$DatasetName'Variance@'$mapset method=variance
	r.series input="`g.mlist pattern='*WSA_vis' sep=,`" output=$DatasetName'StdDev@'$mapset method=stddev
elif [ $DatasetName == "WSA_nir" ]; then
	r.series input="`g.mlist pattern='*WSA_nir' sep=,`" output=$DatasetName'Average@'$mapset method=average
	r.series input="`g.mlist pattern='*WSA_nir' sep=,`" output=$DatasetName'Variance@'$mapset method=variance
	r.series input="`g.mlist pattern='*WSA_nir' sep=,`" output=$DatasetName'StdDev@'$mapset method=stddev
elif [ $DatasetName == "WSA_shortwave" ]; then
	r.series input="`g.mlist pattern='*WSA_shortwave' sep=,`" output=$DatasetName'Average@'$mapset method=average
	r.series input="`g.mlist pattern='*WSA_shortwave' sep=,`" output=$DatasetName'Variance@'$mapset method=variance
	r.series input="`g.mlist pattern='*WSA_shortwave' sep=,`" output=$DatasetName'StdDev@'$mapset method=stddev
fi

#export the final outputs
# r.out.gdal input=$DatasetName'Average@'$mapset output=$OutputDir/$DatasetName'Average.tif' type=UInt16 
r.out.gdal input=$DatasetName'Average@'$mapset output=$OutputDir/$DatasetName'Average.tif'
# r.out.gdal input=$DatasetName'Variance@'$mapset output=$OutputDir/$DatasetName'Variance.tif' type=UInt16
r.out.gdal input=$DatasetName'Variance@'$mapset output=$OutputDir/$DatasetName'Variance.tif'
# r.out.gdal input=$DatasetName'StdDev@'$mapset output=$OutputDir/$DatasetName'StdDev.tif' type=UInt16
r.out.gdal input=$DatasetName'StdDev@'$mapset output=$OutputDir/$DatasetName'StdDev.tif'

# # if you want to remove input grids when calculations are completed-
# data=$(g.mlist type=rast pattern=$DatasetName mapset=PERMANENT) 
# while read data
# do
# 	g.remove $data@PERMANENT
# done

####################################################################
####################################################################

# remove internal tmp stuff:
$GISBASE/etc/clean_temp  || error_routine "clean_temp"
rm -rf $TMPDIR/grass6-$USER-$GIS_LOCK
