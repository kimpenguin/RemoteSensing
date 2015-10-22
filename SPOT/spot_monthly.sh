#!/bin/bash
#
#/data7/scripts/./spot_monthly.sh /data7/M001334_FAPAR/Africa FPAR Geographic spot

#parameters given by the user are assigned to variables that will be used within the script
InputDir=$1
DatasetName=$2
location=$3
mapset=$4

######Starting GRASS Environment
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
# g.gisenv -n

######


cd $InputDir
OutputDir=$InputDir/output
mkdir $OutputDir

months="01 02 03 04 05 06 07 08 09 10 11 12"

time for eachMonth in $months
do
	echo $eachMonth
	list=$(ls | grep "^....$eachMonth")

	for filedir in $list
	do
		echo $filedir
		cd $InputDir/$filedir
		fileNam=$(ls *tiff)
		# echo $file
		newfileNam=$(echo $fileNam | sed "s/.tiff//")
		echo importing $newfileNam
		r.in.gdal -o input=$InputDir/$filedir/$fileNam output=$newfileNam #bytes=4 north=40 south=-40 east=60 west=-20 rows=320 cols=320 anull=NaN 

		#will be used to store the name of each sum file
		strValue+="$newfileNam"@"$mapset"
		# echo $strValue
		cd $InputDir
	done
	# # set g.region to current file
	g.region rast="$newfileNam"@"$mapset"

	strFiles=$(echo $strValue | sed "s/@"$mapset"/@"$mapset",/g")
	# echo $strFiles
	comFiles=$(echo $strFiles | sed "s/.$//")
	# echo $comFiles

	#calculates time series average, variance, standard deviation
	r.series input=$comFiles output="$DatasetName"_"$eachMonth"_avg method=average
	
	# export average variance standard deviation into output directory
	r.out.gdal input="$DatasetName"_"$eachMonth"_avg@"$mapset" output=$OutputDir/"$DatasetName"_"$eachMonth"_avg.tif
	chmod 775 $OutputDir/"$DatasetName"_"$eachMonth"_avg.tif

	g.remove rast=$comFiles

	strValue=""
	echo new is $strValue

done
