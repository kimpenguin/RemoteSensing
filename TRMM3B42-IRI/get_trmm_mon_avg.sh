#!/bin/bash
#get_trmm_dataIRI.sh
#script by Kimberly Peng
#date created: December 2013

#/data4/ErosionMapping/TRMM/scripts/./get_trmm_mon_avg.sh /data4/ErosionMapping/TRMM/TRMMmonthlyAfrica 1998 2015 Geographic trmm

#parameters given by the user are assigned to variables that will be used within the script
InputDir=$1
# OutputDir=$2
startYear=$2
endYear=$3
location=$4
mapset=$5


#####################STARTING THE GRASS ENVIRONMENT
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

###################################

#DOWNLOADING BINARIES
cd $InputDir
OutputDir=$InputDir/output
mkdir $OutputDir
months="Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"
i=1
for eachMonth in $months  
do
	echo $eachMonth
	#downloads the binary r4 file from the IRI data Library	
	#curl http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/X/-20/60/RANGEEDGES/Y/40/-40/RANGEEDGES/T/%28"$startYear"%29%28"endYear"%29RANGE/T/%28"$eachMonth"%29VALUES%5BT%5Daverage/data.r4 -o $InputDir/trmm_"$startYear"_"$endYear"_$"eachMonth".r4
	echo "http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/X/-20/60/RANGEEDGES/Y/40/-40/RANGEEDGES/T/%28"$startYear"%29%28"$endYear"%29RANGE/T/%28"$eachMonth"%29VALUES%5BT%5Daverage"
	curl "http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/X/-20/60/RANGEEDGES/Y/40/-40/RANGEEDGES/T/%28"$startYear"%29%28"$endYear"%29RANGE/T/%28"$eachMonth"%29VALUES%5BT%5Daverage/data.r4" -o $InputDir/trmm_"$startYear"_"$endYear"_"$eachMonth".r4

	#GRASS
	#importing the binary r4 file into grass mapset
	echo importing trmm_"$startYear"_"$endYear"_"$eachMonth".r4 into grass
	r.in.bin -f -s -b --overwrite input=$InputDir/trmm_"$startYear"_"$endYear"_"$eachMonth".r4 output=trmm_"$startYear"_"$endYear"_"$eachMonth"  bytes=4 north=40 south=-40 east=60 west=-20 rows=320 cols=320 anull=NaN 

	#Geotiff outputs for each tile containing the time series sum of the data set
	echo exporting trmm_$currentObs as tif 
	r.out.gdal input=trmm_"$startYear"_"$endYear"_"$eachMonth"@"$mapset" output=$OutputDir/trmm_"$startYear"_"$endYear"_"$eachMonth".tif
	chmod 775 $OutputDir/trmm_"$startYear"_"$endYear"_"$eachMonth".tif
	###

	#increments i for the next observation
	i=$((i+1))
done

$GISBASE/etc/clean_temp  || error_routine "clean_temp"
rm -rf $TMPDIR/grass6-$USER-$GIS_LOCK