#!/bin/bash
#get_trmm_avg_time_series.sh
#script by Kimberly Peng
#date created: December 2013
#Creates time series average of all the TRMM observations available.

#WARNING! Run the get_trmm_dataIRI.sh before running this script.

#HOW TO RUN!
#The line below is an example command for how to run this script from the UNIX command line
#It contains the following: calls script to run, giving it 4 parameters - Input directory, output directory, GRASS location, GRASS mapset
#/data4/ErosionMapping/TRMM/scripts/./get_trmm_avg_time_seriesiri.sh /data4/ErosionMapping/TRMM/TRMMdailyAfrica 1998 2015 Geographic trmm

#parameters given by the user are assigned to variables that will be used within the script
InputDir=$1
startYear=$2
endYear=$3
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

#initialize g.region for geographic trmm data
g.region n=40 s=-40 e=60 w=-20 rows=320 cols=320

######
cd $InputDir
OutputDir=$InputDir/output
mkdir $OutputDir

echo "http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/X/-20/60/RANGEEDGES/Y/40/-40/RANGEEDGES/T/("$startYear")/("$endYear")/RANGE/%5BT%5Daverage"
curl "http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/X/-20/60/RANGEEDGES/Y/40/-40/RANGEEDGES/T/("$startYear")/("$endYear")/RANGE/%5BT%5Daverage/data.r4" -o $InputDir/trmm_avg_"$startYear"_"$endYear".r4

#GRASS
#importing the binary r4 file into grass mapset
echo importing trmm_avg_"$startYear"_"$endYear".r4 into grass
r.in.bin -f -s -b --overwrite input=$InputDir/trmm_avg_"$startYear"_"$endYear".r4 output=trmm_avg_"$startYear"_"$endYear"  bytes=4 north=40 south=-40 east=60 west=-20 rows=320 cols=320 anull=NaN 

#Geotiff outputs for each tile containing the time series sum of the data set
echo exporting trmm_$currentObs as tif 
r.out.gdal input=trmm_avg_"$startYear"_"$endYear"@"$mapset" output=$OutputDir/trmm_avg_"$startYear"_"$endYear".tif
chmod 775 $OutputDir/trmm_avg_"$startYear"_"$endYear".tif



