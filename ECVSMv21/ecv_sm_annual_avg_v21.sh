#!/bin/bash
#get_trmm_avg_time_series.sh
#script by Kimberly Peng
#date created: April 2014
#Creates time series average of all the Essential Climate Variable soil moisture observations available.
#A scale factor of 0.0001 must be applied.

#HOW TO RUN!
#The line below is an example command for how to run this script from the UNIX command line
#It contains the following: calls script to run, giving it 4 parameters - Input directory, output directory, GRASS location, GRASS mapset
#/data4/ECV_Soil_Moisture/Version2.1/scripts/./ecv_sm_annual_avg_v21.sh /data4/ECV_Soil_Moisture/Version2.1/active/geotiffs /data4/ECV_Soil_Moisture/Version2.1/active/annual_avg v2active 1991 2013 Geographic ecv21
#/data4/ECV_Soil_Moisture/Version2.1/scripts/./ecv_sm_annual_avg_v21.sh /data4/ECV_Soil_Moisture/Version2.1/passive/geotiffs /data4/ECV_Soil_Moisture/Version2.1/passive/annual_avg v2passive 1978 2013 Geographic ecv21p
#/data4/ECV_Soil_Moisture/Version2.1/scripts/./ecv_sm_annual_avg_v21.sh /data4/ECV_Soil_Moisture/Version2.1/combined/geotiffs /data4/ECV_Soil_Moisture/Version2.1/combined/annual_avg v2combined 1978 2013 Geographic ecv21c

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
	r.series input=${obsList[@]} output=ecv_sm_"$dataSource"_avg1_"$startYear" method=average
	#applies scale factor 0.0001
	r.mapcalculator amap=ecv_sm_"$dataSource"_avg1_"$startYear"@"$mapset" formula="A*0.0001" outfile=ecv_sm_"$dataSource"_avg_"$startYear"
	r.out.gdal input=ecv_sm_"$dataSource"_avg_"$startYear"@"$mapset" output=$OutputDir/ecv_sm_"$dataSource"_avg_"$startYear".tif
	chmod 775 $OutputDir/ecv_sm_"$dataSource"_avg_"$startYear".tif


	#calculates annual variance and exports
	r.series input=${obsList[@]} output=ecv_sm_"$dataSource"_var1_"$startYear" method=variance
	#applies scale factor 0.0001
	r.mapcalculator amap=ecv_sm_"$dataSource"_var1_"$startYear"@"$mapset" formula="A*0.0001" outfile=ecv_sm_"$dataSource"_var_"$startYear"
	r.out.gdal input=ecv_sm_"$dataSource"_var_"$startYear"@"$mapset" output=$OutputDir/ecv_sm_"$dataSource"_var_"$startYear".tif
	chmod 775 $OutputDir/ecv_sm_"$dataSource"_var_"$startYear".tif
	
	#increment current year to loop through next year
	startYear=$((startYear+1))
done
