#!/bin/bash
#get_chirps_ts.sh
#Create time series of all CHIRPS data
#Written by Kimberly Peng
#Created February 2016
#/data2/CHIRPS/scripts/get_chirps_ts.sh /data2/CHIRPS/raws /data2/CHIRPS/scripts 1981 2015 geographic chirps2

#Parameters
InputDir=$1
OutputDir=$2
StartYear=$3
EndYear=$4
location=$5
mapset=$6

######STARTING THE GRASS ENVIRONMENT
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
mkdir /data2/grassdata/$location/$mapset
cp /data2/grassdata/$location/PERMANENT/WIND /data2/grassdata/$location/$mapset

# generate GRASS settings file:
# the file contains the GRASS variables which define the LOCATION etc.
echo "GISDBASE: /data2/grassdata
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
g.region n=40 s=-40 e=60 w=-20 res=0.05
#####

##### DETERMINE TOTAL NUMBER OF OBSERVATIONS IN TEMPORAL RANGE
#creates a text file containing the year and the number of observations in that year.
cd $InputDir
d=$(date '+%Y%m%d-%H:%M:%S')
touch $InputDir/chirps_obs_$d.txt
y=$StartYear
while [ $y -le $EndYear ]
do
	# echo "Number of observations for" $y >> $InputDir/chirps_obs.txt
	cd $InputDir/$y
	tifList=$(ls *.tif)
	arr=($tifList)
	echo $y":"${#arr[@]} >> $InputDir/chirps_obs_$d.txt

	y=$((y+1))
done

# $ echo $var | sed 's/.*://'
#lists years and number of observations on the command line.
incrementalNum=0
for eachFile in $(cat $InputDir/chirps_obs_$d.txt); do
	# echo incrementalNum is $incrementalNum
	curNum=$(echo $eachFile | sed 's/.*://')
	# echo curNum is $curNum
	newVal=$((curNum+incrementalNum))
	incrementalNum=$newVal
done
echo Total number of CHIRPS observations from "$StartYear" to "$EndYear" is "$incrementalNum"

#####CREATE AVERAGE FOR TEMPORAL RANGE
#create output directory
OutputDir=$InputDir/outputs
mkdir $OutputDir

y=$StartYear
while [ $y -le $EndYear ]
do
	echo Current Year $y
	cd $InputDir/$y
	tifList=$(ls *.tif)
	annualList="" #initalize list to store names of current year's observations
	for eachTif in $tifList
	do
		echo importing $eachTif
		newName=$(echo $eachTif | sed "s/.tif//")
		# echo $newName
		# import each file in date list
		r.in.gdal input=$InputDir/$y/$eachTif output=$newName
		r.null map="$newName"@"$mapset" setnull=-9999 

		#create a list of all year files
		annualList+=$eachTif" "

	done
	echo annual list is $annualList
	# echo series list is $tsList
	rsAnnualList=$(echo $annualList | sed "s/ /,/g;s/.tif/@"$mapset"/g")
	# echo $rsAnnualList
	#calculate export annual average
	r.series input=$rsAnnualList output=CHIRPS_sum_"$y" method=sum
	# r.out.gdal input=CHIRPS_sum_"$y"@"$mapset" output=$OutputDir/CHIRPS_sum_"$y".tif
	# chmod 775 $OutputDir/CHIRPS_sum_"$y".tif

	#add name to time series list
	tsList+=CHIRPS_sum_"$y"@"$mapset"" "

	# remove raws
	g.remove rast="$rsAnnualList"
	y=$((y+1))
done

# rsTSList=$(echo $tsList | sed "s/ /,/g;s/.tif/@"$mapset"/g")
rsTSList=$(echo $tsList | sed "s/ /,/g")
echo $rsTSList
#creates a sum of all the years
r.series input=$rsTSList output=CHIRPS_sum_"$StartYear"_"$EndYear" method=sum

#calculates average
r.mapcalculator amap=CHIRPS_sum_"$StartYear"_"$EndYear"@"$mapset" formula="A/$incrementalNum" outfile=CHIRPS_avg_"$StartYear"_"$EndYear"
r.out.gdal input=CHIRPS_avg_"$StartYear"_"$EndYear"@"$mapset" output=$OutputDir/CHIRPS_avg_"$StartYear"_"$EndYear".tif
chmod 775 $OutputDir/CHIRPS_avg_"$StartYear"_"$EndYear".tif


