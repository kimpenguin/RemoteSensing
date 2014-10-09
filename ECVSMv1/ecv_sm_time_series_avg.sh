#!/bin/bash
#get_trmm_avg_time_series.sh
#script by Kimberly Peng
#date created: December 2013
#Creates time series average of all the ECV soil moisture observations available.

#HOW TO RUN!
#The line below is an example command for how to run this script from the UNIX command line
#It contains the following: calls script to run, giving it 4 parameters - Input directory, output directory, GRASS location, GRASS mapset
#/data4/ECV_Soil_Moisture/scripts/./ecv_sm_time_series_avg.sh /data4/ECV_Soil_Moisture/Data /data4/ECV_Soil_Moisture/time_series_avg Geographic ecv

#parameters given by the user are assigned to variables that will be used within the script
InputDir=$1
OutputDir=$2
location=$3
mapset=$4

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

#initialize g.region
g.region n=40 s=-40 e=60 w=-20 rows=320 cols=320

######

firstYear=1978
startYear=1978
endYear=2010

while [ $startYear -le $endYear ]
do
	echo current year is $startYear
	#changes into directory of current year
	cd $InputDir/$startYear

	#creates a list of all the geotiff inputs
	geotiflist=$(ls ecv_*.tif)
	#echo $geotiflist
	i=1
	#imports each observation in current year
	for fileNam in $geotiflist
	do
		echo $fileNam
		newfileNam=$(echo $fileNam | sed "s/.tif//")
#		r.in.gdal input=$InputDir/$startYear/$fileNam output=$newfileNam
		#generates a new raster that has 1 or 0 at each pixel representing whether or not there is an observation
		r.mapcalculator amap="$newfileNam"@"$mapset" formula="if(A,(A-A)+1)" outfile=observations_"$startYear"_$i
		i=$((i+1))
	done

	obsList=$(echo ${geotiflist[@]} | sed "s/ /,/g;s/.tif/@"$mapset"/g")
	#calculates annual sum
	r.series input=${obsList[@]} output=sumObs_"$startYear" method=sum

	r.series input="`g.mlist pattern='observations*' sep=,`" output=totalObs_"$startYear" method=sum
	g.remove rast="`g.mlist pattern='observations*' sep=,`"

	#increment current year to loop through next year
	startYear=$((startYear+1))
done

#calculates total sum of all observations
r.series input="`g.mlist pattern='sumObs*' sep=,`" output=ecv_sm_sum_"$firstYear"_"$endYear" method=sum
g.remove rast="`g.mlist pattern='sumObs*' sep=,`"

#creates cumulative sum to generate total number of observations per pixel
r.series input="`g.mlist pattern='totalObs*' sep=,`" output=ecv_sm_totalObs_"$firstYear"_"$endYear" method=sum
g.remove rast="`g.mlist pattern='totalObs*' sep=,`"

#calculates time series average
r.mapcalculator amap=ecv_sm_sum_"$firstYear"_"$endYear"@"$mapset" bmap=ecv_sm_totalObs_"$firstYear"_"$endYear"@"$mapset" formula="(A/B)" outfile=ecv_sm_avg_"$firstYear"_"$endYear"
r.out.gdal input=ecv_sm_avg_"$firstYear"_"$endYear"@"$mapset" output=$OutputDir/ecv_sm_avg_"$firstYear"_"$endYear".tif
chmod 775 $OutputDir/ecv_sm_avg_"$firstYear"_"$endYear".tif
