#!/bin/bash
#get_trmm_avg_time_series.sh
#script by Kimberly Peng
#date created: December 2013
#Creates time series average of all the ECV soil moisture observations available.

#HOW TO RUN!
#The line below is an example command for how to run this script from the UNIX command line
#It contains the following: calls script to run, giving it 4 parameters - Input directory, output directory, GRASS location, GRASS mapset
#/data4/ECV_Soil_Moisture/Version2.1/scripts/./ecv_sm_time_series_avg_v21.sh /data4/ECV_Soil_Moisture/Version2.1/active/geotiffs /data4/ECV_Soil_Moisture/Version2.1/active/time_series_avg 1991 2013 Geographic ecv21
#/data4/ECV_Soil_Moisture/Version2.1/scripts/./ecv_sm_time_series_avg_v21.sh /data4/ECV_Soil_Moisture/Version2.1/passive/geotiffs /data4/ECV_Soil_Moisture/Version2.1/passive/time_series_avg 1978 2013 Geographic ecv21p
#/data4/ECV_Soil_Moisture/Version2.1/scripts/./ecv_sm_time_series_avg_v21.sh /data4/ECV_Soil_Moisture/Version2.1/combined/geotiffs /data4/ECV_Soil_Moisture/Version2.1/combined/time_series_avg 1978 2013 Geographic ecv21c

#parameters given by the user are assigned to variables that will be used within the script
InputDir=$1
OutputDir=$2
startYear=$3
endYear=$4
location=$5
mapset=$6

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

firstYear=$startYear

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
		# extracts the dataset name
		datasetName=$(echo $fileNam | sed -r "s/.{13}$//")

		newfileNam=$(echo $fileNam | sed "s/.tif//")
		r.in.gdal input=$InputDir/$startYear/$fileNam output=$newfileNam

		# #generates a new raster that has 1 or 0 at each pixel representing whether or not there is an observation
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
r.series input="`g.mlist pattern='sumObs*' sep=,`" output="$datasetName"_sum_"$firstYear"_"$endYear" method=sum
g.remove rast="`g.mlist pattern='sumObs*' sep=,`"

#creates cumulative sum to generate total number of observations per pixel
r.series input="`g.mlist pattern='totalObs*' sep=,`" output="$datasetName"_totalObs_"$firstYear"_"$endYear" method=sum
g.remove rast="`g.mlist pattern='totalObs*' sep=,`"

#calculates time series average and applies scale factor of 0.0001
r.mapcalculator amap="$datasetName"_sum_"$firstYear"_"$endYear"@"$mapset" bmap="$datasetName"_totalObs_"$firstYear"_"$endYear"@"$mapset" formula="(A/B)*0.0001" outfile="$datasetName"_avg_"$firstYear"_"$endYear"
r.out.gdal input="$datasetName"_avg_"$firstYear"_"$endYear"@"$mapset" output=$OutputDir/"$datasetName"_avg_"$firstYear"_"$endYear".tif
chmod 775 $OutputDir/"$datasetName"_avg_"$firstYear"_"$endYear".tif

