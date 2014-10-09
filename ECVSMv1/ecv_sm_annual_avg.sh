#!/bin/bash
#get_trmm_avg_time_series.sh
#script by Kimberly Peng
#date created: April 2014
#Creates time series average of all the Essential Climate Variable soil moisture observations available.

#HOW TO RUN!
#The line below is an example command for how to run this script from the UNIX command line
#It contains the following: calls script to run, giving it 4 parameters - Input directory, output directory, GRASS location, GRASS mapset
#/data4/ECV_Soil_Moisture/scripts/./ecv_sm_annual_avg.sh /data4/ECV_Soil_Moisture/Data /data4/ECV_Soil_Moisture/annual_avg Geographic ecv

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

	#imports each observation in current year
	for fileNam in $geotiflist
	do
		echo $fileNam
		newfileNam=$(echo $fileNam | sed "s/.tif//")
		r.in.gdal input=$InputDir/$startYear/$fileNam output=$newfileNam  
	done
	
	obsList=$(echo ${geotiflist[@]} | sed "s/ /,/g;s/.tif/@"$mapset"/g")

	#calculates annual average and exports
	r.series input=${obsList[@]} output=ecv_sm_avg_"$startYear" method=average
	r.out.gdal input=ecv_sm_avg_"$startYear"@"$mapset" output=$OutputDir/ecv_sm_avg_"$startYear".tif
	chmod 775 $OutputDir/ecv_sm_avg_"$startYear".tif

	#calculates annual variance and exports
	r.series input=${obsList[@]} output=ecv_sm_var_"$startYear" method=variance
	r.out.gdal input=ecv_sm_var_"$startYear"@"$mapset" output=$OutputDir/ecv_sm_var_"$startYear".tif
	chmod 775 $OutputDir/ecv_sm_var_"$startYear".tif
	
	#increment current year to loop through next year
	startYear=$((startYear+1))
done
