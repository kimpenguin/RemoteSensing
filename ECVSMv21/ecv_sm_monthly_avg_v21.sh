#!/bin/bash
#get_trmm_avg_time_series.sh
#script by Kimberly Peng
#date created: December 2013
#Creates time series monthly average of all the ECV soil moisture observations available.

#HOW TO RUN!
#The line below is an example command for how to run this script from the UNIX command line
#It contains the following: calls script to run, giving it 4 parameters - Input directory, output directory, GRASS location, GRASS mapset
#/data4/ECV_Soil_Moisture/Version2.1/scripts/./ecv_sm_monthly_avg_v21.sh /data4/ECV_Soil_Moisture/Version2.1/combined/geotiffs /data4/ECV_Soil_Moisture/Version2.1/combined/time_series_monthly_avg v2combined 1978 2013 Geographic ecv21c

#parameters given by the user are assigned to variables that will be used within the script
InputDir=$1
OutputDir=$2
dataSource=$3
startYear=$4
endYear=$5
location=$6
mapset=$7

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
months="01 02 03 04 05 06 07 08 09 10 11 12"

for eachMonth in $months  
do
	#empty array
	tiflist=()

	echo current month is $eachMonth
	startYear=$firstYear #reinitialize the start year to continue the following loop
	#loops through all they years to extract files for the current month
	while [ $startYear -le $endYear ]
	do
		echo current year is $startYear
		#changes into directory of current year
		cd $InputDir/$startYear
   		
		#creates a list of all the geotiff inputs
		geotiflist=$(ls ecv_sm_"$dataSource"_"$startYear""$eachMonth"*.tif)
		echo GEOTIFLIST IS $geotiflist
		
		#imports each observation in current year
		for fileNam in $geotiflist
		do
			echo $fileNam
			newfileNam=$(echo $fileNam | sed "s/.tif//")
			r.in.gdal input=$InputDir/$startYear/$fileNam output=$newfileNam 
		done


		tiflist=( ${tiflist[@]} ${geotiflist[@]} )
		echo $tiflist
		startYear=$((startYear+1))
	done	
	#echo TIFLIST IS ${tiflist[@]}
	#modifies list containing names of observations for rseries use
	obsList=$(echo ${tiflist[@]} | sed "s/ /,/g;s/.tif/@"$mapset"/g")
	
	#calculates time series monthly average and exports
	r.series input=${obsList[@]} output=ecv_sm_"$dataSource"_avg_"$firstYear"_"$endYear"_"$eachMonth" method=average
	r.out.gdal input=ecv_sm_"$dataSource"_avg_"$firstYear"_"$endYear"_"$eachMonth"@"$mapset" output=$OutputDir/ecv_sm_"$dataSource"_avg_"$firstYear"_"$endYear"_"$eachMonth".tif
	chmod 775 $OutputDir/ecv_sm_"$dataSource"_avg_"$firstYear"_"$endYear"_"$eachMonth".tif
	
done
