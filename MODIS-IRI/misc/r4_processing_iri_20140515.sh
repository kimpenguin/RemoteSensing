#!/bin/bash
#This script will be used to download and mosaic the time series average of MODIS data sets hosted by the IRI Data Library

##############################################################################
#Input parameters: 
#/data4/afsisdata/IRI_MODIS/scripts/./r4_processing_iri_20140515.sh /data4/afsisdata/IRI_MODIS/annual/EVI/2000 EVI sinusoidalSA updatesKP


InputDir=$1
#OutputDir=$2
DatasetName=$2
location=$3
mapset=$4

FileType=Float32
perform=annual

#conditional statement reassigns the correct IRI Data Library name for the requested data set.
if [ "$DatasetName" == "evi" ] || [ "$DatasetName" == "EVI" ]; then
	DatasetName=EVI
	DatasetRes=250
	DatasetRow=4800
	DatasetCol=4800
	IriRes=global250m
elif [ "$DatasetName" == "ndvi" ] || [ "$DatasetName" == "NDVI" ]; then
	DatasetName=NDVI
	DatasetRes=250
	DatasetRow=4800
	DatasetCol=4800
	IriRes=global250m
elif [ "$DatasetName" == "blue" ] || [ "$DatasetName" == "reflectance_blue" ]; then
	DatasetName=reflectance_blue
	DatasetRes=250
	DatasetRow=4800
	DatasetCol=4800
	IriRes=global250m
elif [ "$DatasetName" == "red" ] || [ "$DatasetName" == "reflectance_red" ]; then
	DatasetName=reflectance_red
	DatasetRes=250
	DatasetRow=4800
	DatasetCol=4800
	IriRes=global250m
elif [ "$DatasetName" == "mir" ] || [ "$DatasetName" == "MIR" ] || [ "$DatasetName" == "reflectance_MIR" ]; then
	DatasetName=reflectance_MIR
	DatasetRes=250
	DatasetRow=4800
	DatasetCol=4800
	IriRes=global250m
elif [ "$DatasetName" == "nir" ] || [ "$DatasetName" == "NIR" ] || [ "$DatasetName" == "reflectance_NIR" ]; then
	DatasetName=reflectance_NIR
	DatasetRes=250
	DatasetRow=4800
	DatasetCol=4800
	IriRes=global250m
elif [ "$DatasetName" == "lst_day" ] || [ "$DatasetName" == "LST_Day_1km" ]; then
	DatasetName=LST_Day_1km
	DatasetRes=1000
	DatasetRow=1200
	DatasetCol=1200
	IriRes=global
elif [ "$DatasetName" == "lst_night" ] || [ "$DatasetName" == "LST_Night_1km" ]; then
	DatasetName=LST_Night_1km
	DatasetRes=1000
	DatasetRow=1200
	DatasetCol=1200
	IriRes=global
fi       

######################################STARTING THE GRASS ENVIRONMENT
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
    rm $InputDir/"$DatasetName"_avgIRI_"$StartMonth""$StartYear"_"$EndMonth""$EndYear"_$eachnotAfrica.r4
done

################################

cd $InputDir
arr=(`ls "$DatasetName"*.r4`)
#echo ${arr[@]}
word=${arr[1]}
echo $word
numWord=${#word}
#numObs=${#arr[@]}
#echo number of files is $numObs

OutputDir=$InputDir/geotiffs
mkdir $OutputDir


TileNum1=(2 3 4 5 6 7 8 9) #arrays to loop through each of 64 tiles
TileNum2=(2 3 4 5 6 7 8 9)
Top=(4447803 3335852 2223902 1111952 1 -1111950 -2223900 -3335850) #north
Bottom=(3335852 2223902 1111952 1 -1111950 -2223900 -3335850 -4447801) #south
Right=(-1111952 -2 1111948 2223899 3335849 4447800 5559750 6671700) #east
Left=(-2223903 -1111952 -2 1111948 2223899 3335849 4447800 5559750) #west

#Loops through all the tiles
time for eachTile1 in ${TileNum1[*]}
do
	for eachTile2 in ${TileNum2[*]}
	do 
		echo "$eachTile1"_"$eachTile2"
	
		#prints out the bounds to the screen
		echo north="${Top[$eachTile2-2]}" south="${Bottom[$eachTile2-2]}" east="${Right[$eachTile1-2]}" west="${Left[$eachTile1-2]}" # the "-2" allows you to choose an index value in TileNum
	
		#sets the geographical region for the current tile.
		g.region n=${Top[$eachTile2-2]} s=${Bottom[$eachTile2-2]} e=${Right[$eachTile1-2]} w=${Left[$eachTile1-2]} t=${Top[$eachTile2-2]} b=${Bottom[$eachTile2-2]} rows=$DatasetRow cols=$DatasetCol nsres=$DatasetRes ewres=$DatasetRes
	

		##ANNUAL	
		if [ $perform == "annual" ]; then
			AnnYear=${word:$numWord-11:4}
			echo YEAR IS $AnnYear
			
			#Imports r4 binary files of the tiles containing the average calculated by the IRI Data Library
			echo "$DatasetName"_avgIRI_"$AnnYear"_"$eachTile1"_"$eachTile2".r4
			#import the binary files of calculated averages performed by the IRI Data Library
			r.in.bin -f -s -b --overwrite input=$InputDir/"$DatasetName"_avgIRI_"$AnnYear"_"$eachTile1"_"$eachTile2".r4 output="$DatasetName"_avgIRI_"$AnnYear"_"$eachTile1"_"$eachTile2" bytes=4 north=${Top[$eachTile2-2]} south=${Bottom[$eachTile2-2]} east=${Right[$eachTile1-2]} west=${Left[$eachTile1-2]} rows=$DatasetCol cols=$DatasetCol anull=NaN 

			#Geotiff outputs for each tile containing the time series average performed by the IRI Data Library
			r.out.gdal input="$DatasetName"_avgIRI_"$AnnYear"_"$eachTile1"_"$eachTile2"@"$mapset" type=$FileType output=$OutputDir/"$DatasetName"_avgIRI_"$AnnYear"_"$eachTile1"_"$eachTile2".tif
			chmod 775 $OutputDir/"$DatasetName"_avgIRI_"$AnnYear"_"$eachTile1"_"$eachTile2".tif

			#removes the temporary tile layers
#			g.remove rast="$DatasetName"_avgIRI_"$AnnYear"_"$eachTile1"_"$eachTile2"@"$mapset"
		##END ANNUAL

		fi
	done
done

########################################MOSAICKING AND REPROJECTING TO LAMBERT, EXPORT TO DIRECTORY ON SERVER
cd $OutputDir

if [ $perform == "annual" ]; then
	#list all tif in directory
	tiflist=$(ls "$DatasetName"_avgIRI_"$AnnYear"*.tif|grep -v "mosaic")
	echo $tiflist

	#mosaic all images in tiflist
	time gdal_merge.py -n NaN -of GTiff -o $OutputDir/"$DatasetName"_avgIRI_"$AnnYear"'_mosaic.tif' $tiflist

	#reproject using gdal-option 1 (esp useful if grid in not in grass database) -- to remove 250x250 and leave at orig res take out: -tr $DatasetRes $DatasetRes, and remove '250' from $OutputDir/$DatasetName'_250mosaicLAEA.tif'
	time gdalwarp -overwrite -s_srs '+proj=sinu +lon_0=0 +x_0=0 +y_0=0 +a=6371007.181 +b=6371007.181 +units=m +no_defs' -t_srs '+proj=laea +lat_0=5 +lon_0=20 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs' $OutputDir/"$DatasetName"_avgIRI_"$AnnYear"'_mosaic.tif' $OutputDir/"$DatasetName"_avgIRI_"$AnnYear"'_mosaicLAEA.tif' -multi -wm 5000

	#changes the permissions for the calculated average and sum
	chmod 775 $OutputDir/"$DatasetName"_avgIRI_"$AnnYear"'_mosaicLAEA.tif'
fi

##############################################################################
# remove internal tmp stuff:
$GISBASE/etc/clean_temp  || error_routine "clean_temp"
rm -rf $TMPDIR/grass6-$USER-$GIS_LOCK


