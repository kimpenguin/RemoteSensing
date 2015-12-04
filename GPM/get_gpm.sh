#!/bin/bash

#/data2/GPM/scripts/get_gpm.sh /data2/GPM 2014 2015 cea GPM
#/data2/GPM/scripts/get_gpm.sh /data2/GPM 2014 2015 geographic GPM

#Parameters
InputDir=$1
StartYear=$2
EndYear=$3
location=$4
mapset=$5

#change to the Input directory location
cd $InputDir
#create directory to store raw data
RawDir=$InputDir/raws
mkdir $RawDir
#####DOWNLOAD DATA
# #gets a list of directories
# curl ftp://arthurhou.pps.eosdis.nasa.gov/gpmdata/ --user kmp2143@columbia.edu:kmp2143@columbia.edu > dirDates.txt

# months="01 02 03 04 05 06 07 08 09 10 11 12"
# days="01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31"

# year=$StartYear
# while [ $((year)) -le $((EndYear)) ]
# do
# 	echo Start Year is $year
# 	i=1
# 	for newWord in $(cat dirDates.txt); do
# 		if [ $((i%9)) -eq 0 ] && [ ${newWord:0:4} == $year ]; then
# 			echo year is $newWord
# 			curl ftp://arthurhou.pps.eosdis.nasa.gov/gpmdata/$newWord/ --user kmp2143@columbia.edu:kmp2143@columbia.edu > dirDates_"$newWord".txt
# 			for eachMonth in $months
# 			do
# 				echo month is $eachMonth
# 				for eachDay in $days
# 				do
# 					echo day is $eachDay
# 					echo "$newWord""$eachMonth""$eachDay"_toDownload.txt
# 					echo ftp://arthurhou.pps.eosdis.nasa.gov/gpmdata/"$newWord"/"$eachMonth"/"$eachDay"/
# 					curl ftp://arthurhou.pps.eosdis.nasa.gov/gpmdata/"$newWord"/"$eachMonth"/"$eachDay"/gis/ --user kmp2143@columbia.edu:kmp2143@columbia.edu > "$newWord""$eachMonth""$eachDay"_toDownload.txt
# 					# loop through text file to download the tifs
# 					for newFile in $(cat "$newWord""$eachMonth""$eachDay"_toDownload.txt); do
# 						if [ ${newFile:0:2} == "3B" ]; then
# 							echo ftp://arthurhou.pps.eosdis.nasa.gov/gpmdata/"$newWord"/"$eachMonth"/"$eachDay"/gis/"$newFile"
# 							curl ftp://arthurhou.pps.eosdis.nasa.gov/gpmdata/"$newWord"/"$eachMonth"/"$eachDay"/gis/"$newFile" --user kmp2143@columbia.edu:kmp2143@columbia.edu -o $RawDir/$newFile
# 						fi
# 					done
# 				done
# 			done

# 		fi
# 			i=$((i+1))
# 	done
# 	year=$((year+1))
# done
#####

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

g.region n=40 s=-40 e=60 w=-20 res=0.1
#g.gisenv -n
#####

#####IMPORT DATA INTO GRASS
datelist=$(ls 2*.txt)
cd $RawDir
SumDir=$InputDir/sums
mkdir $SumDir
#loop through each date
for d in $datelist
do
	fileDate=${d:0:8}
	dlist=$(ls 3B-HHR-*"$fileDate"*.tif) #creates a list of all files for specific date
	# echo $tiflist

	for dFile in $dlist
	do
		# echo $dFile
		newName=$(echo $dFile | sed "s/.V03D.tif//")
		# echo $newName
		# import each file in date list
		r.in.gdal -o input=$RawDir/$dFile output=$newName
		# g.region rast="$newName"@"$mapset"
		r.null map="$newName"@"$mapset" setnull=9999
		r.null map="$newName"@"$mapset" setnull=0
	done
	rsList=$(echo $dlist | sed "s/ /,/g;s/.V03D.tif/@"$mapset"/g")
	# echo $rsList
	r.series input=$rsList output=GPM_IMERG_"$fileDate" method=sum
	r.out.gdal input=GPM_IMERG_"$fileDate"@"$mapset" output=$SumDir/GPM_IMERG_"$fileDate".tif
	chmod 775 $SumDir/GPM_IMERG_"$fileDate".tif
done
#####CREATE TIME Series
OutputDir=$InputDir/output
mkdir $OutputDir
cd $SumDir
sumlist=$(ls GPM*.tif)
echo $sumlist

rsSumList=$(echo $sumlist | sed "s/ /,/g;s/.tif/@"$mapset"/g")
echo $rsSumList
g.remove rast=GPM_IMERG_"$StartYear"_"$EndYear"@"$mapset"
r.series input=$rsSumList output=GPM_IMERG_"$StartYear"_"$EndYear" method=average
r.out.gdal input=GPM_IMERG_"$StartYear"_"$EndYear"@"$mapset" output=$OutputDir/GPM_IMERG_"$StartYear"_"$EndYear".tif
chmod 775 $OutputDir/GPM_IMERG_"$StartYear"_"$EndYear".tif


