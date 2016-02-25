#!/bin/bash
#get_mondata_IRI_MODIS250m.sh
#Written by: Kimberly Peng
#Created: 2012
#This script creates a monthly average of the MODIS Vegetation 250m datasets for a specified temporal range.
#/data4/afsisdata/IRI_MODIS/scripts/./get_mondata_IRI_MODIS250m.sh EVI Feb 2000 Jun 2015 /data7/MODIS/EVI/monthly sinusoidalSA modis
Dataset=$1
StartMonth=$2
StartYear=$3
EndMonth=$4
EndYear=$5
MainDirectory=$6
location=$7
mapset=$8

DatasetRes=250
DatasetRow=4800
DatasetCol=4800
FileType=Float32

productName="$Dataset"_avgIRI_"$StartMonth""$StartYear"_"$EndMonth""$EndYear"

cd $MainDirectory
InputDir=$MainDirectory/inputs
mkdir $InputDir

#####STARTING THE GRASS ENVIRONMENT#####
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

#initialize g.region for sinusoidal
g.region n=4447803 s=-4447797 e=6671705 w=-2223903 rows=$DatasetRow cols=$DatasetCol
#remove unnecessary tiles
notAfrica=(2_2 2_6 2_7 2_8 2_9 3_6 3_7 3_8 3_9 4_7 4_8 4_9 7_2 7_9 8_2 8_3 8_9 9_2 9_3 9_6 9_7 9_8 9_9)
for eachnotAfrica in ${notAfrica[*]}
do 
    rm $InputDir/"$productName"_$eachnotAfrica.r4
done

#static variables to download the calculated average from IRI's Data library
TileNum1=(2 3 4 5 6 7 8 9) #arrays to loop through each of 64 tiles
TileNum2=(2 3 4 5 6 7 8 9)
X=(-1667928 -555977.2 555973.2 1667924 2779874 3891824 5003775 6115725)
Y=(3891828 2779877 1667927 555976.2 -555974.2 -1667925 -2779875 -3891826)

#tile extents
Top=(4447803 3335852 2223902 1111952 1 -1111950 -2223900 -3335850) #north
Bottom=(3335852 2223902 1111952 1 -1111950 -2223900 -3335850 -4447801) #south
Right=(-1111952 -2 1111948 2223899 3335849 4447800 5559750 6671700) #east
Left=(-2223903 -1111952 -2 1111948 2223899 3335849 4447800 5559750) #west

#####DOWNLOAD DATA
# months="Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"
months="Feb"
for eachMonth in $months  
do
   cd $InputDir
   echo current month is $eachMonth
	time for eachTile1 in ${TileNum1[*]}
	do
		for eachTile2 in ${TileNum2[*]}
		do 
			echo "${TileNum1[eachTile1-2]}" "${TileNum2[eachTile2-2]}"
			echo x="${X[$eachTile1-2]}" y="${Y[$eachTile2-2]}"
	
			if [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "2_2" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "2_6" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "2_7" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "2_8" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "2_9" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "3_6" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "3_7" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "3_8" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "3_9" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "4_7" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "4_8" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "4_9" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "7_2" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "7_9" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "8_2" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "8_3" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "8_9" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "9_2" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "9_3" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "9_6" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "9_7" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "9_8" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "9_9" ]; then
				echo Not Africa
			else
				echo downloading "$productName" "$eachMonth" average
				echo "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.250m/.16day/.$Dataset/T/%28"$StartYear"%29%28"$EndYear"%29RANGE/T/%28"$eachMonth"%29VALUES/X/"${X[$eachTile1-2]}"/VALUE/Y/"${Y[$eachTile2-2]}"/VALUE%5BT%5Daverage"
				##################################################
				#downloads the binary r4 files of the monthly average done by the IRI Data Library	
				curl "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.250m/.16day/.$Dataset/T/%28"$StartYear"%29%28"$EndYear"%29RANGE/T/%28"$eachMonth"%29VALUES/X/"${X[$eachTile1-2]}"/VALUE/Y/"${Y[$eachTile2-2]}"/VALUE%5BT%5Daverage/data.r4?filename="$productName"_"$eachMonth"_"${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}".r4" -o $InputDir/"$productName"_"$eachMonth"_"${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}".r4

				#prints out the bounds to the screen
				echo north="${Top[$eachTile2-2]}" south="${Bottom[$eachTile2-2]}" east="${Right[$eachTile1-2]}" west="${Left[$eachTile1-2]}" # the "-2" allows you to choose an index value in TileNum
				
				#sets the geographical region for the current tile.
				g.region n=${Top[$eachTile2-2]} s=${Bottom[$eachTile2-2]} e=${Right[$eachTile1-2]} w=${Left[$eachTile1-2]} t=${Top[$eachTile2-2]} b=${Bottom[$eachTile2-2]} rows=$DatasetRow cols=$DatasetCol nsres=$DatasetRes ewres=$DatasetRes
				
				#####IMPORTING INTO GRASS GIS#####	
				#Imports r4 binary files of the tiles containing the average calculated by the IRI Data Library
				echo "$productName"_"$eachMonth"_"$eachTile1"_"$eachTile2".r4
				#import the binary files of calculated averages performed by the IRI Data Library
				r.in.bin -f -s -b --overwrite input=$InputDir/"$productName"_"$eachMonth"_"$eachTile1"_"$eachTile2".r4 output="$productName"_"$eachMonth"_"$eachTile1"_"$eachTile2" bytes=4 north=${Top[$eachTile2-2]} south=${Bottom[$eachTile2-2]} east=${Right[$eachTile1-2]} west=${Left[$eachTile1-2]} rows=$DatasetCol cols=$DatasetCol anull=NaN 

				#####EXPORTING GEOTIFFS OF FILES TO DIRECTOR ON SERVER#####
				#Geotiff outputs for each tile containing the time series average performed by the IRI Data Library
				r.out.gdal input="$productName"_"$eachMonth"_"$eachTile1"_"$eachTile2"@"$mapset" type=$FileType output=$InputDir/"$productName"_"$eachMonth"_"$eachTile1"_"$eachTile2".tif
				chmod 775 $InputDir/"$productName"_"$eachMonth"_"$eachTile1"_"$eachTile2".tif
			fi
		done
	done
	#####MOSAIC FOR EACH MONTH
	cd $InputDir
	OutputDir=$MainDirectory/outputs
	mkdir $OutputDir
	#list all tif in directory
	tiflist=$(ls "$productName"_"$eachMonth"*.tif|grep -v "mosaic")
	echo $tiflist
	#mosaic all images in tiflist
	time gdal_merge.py -n NaN -of GTiff -o $OutputDir/"$productName"_"$eachMonth"'_mosaic.tif' $tiflist

	#reproject using gdal-option 1 (esp useful if grid in not in grass database) -- to remove 250x250 and leave at orig res take out: -tr $DatasetRes $DatasetRes, and remove '250' from $OutputDir/$DatasetName'_250mosaicLAEA.tif'
	time gdalwarp -overwrite -s_srs '+proj=sinu +lon_0=0 +x_0=0 +y_0=0 +a=6371007.181 +b=6371007.181 +units=m +no_defs' -t_srs '+proj=laea +lat_0=5 +lon_0=20 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs' $OutputDir/"$productName"_"$eachMonth"'_mosaic.tif' $OutputDir/"$productName"_"$eachMonth"'_mosaicLAEA.tif' -multi -wm 5000

	#changes the permissions for the calculated average and sum
	chmod 775 $OutputDir/"$productName"_"$eachMonth"'_mosaicLAEA.tif'
done

#remove inputs directory
rm -r $InputDir
