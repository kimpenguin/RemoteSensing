#!/bin/bash
#This script will be used to download and mosaic the time series average of MODIS data sets hosted by the IRI Data Library

##############################################################################
#Input parameters: 
#/data4/afsisdata/IRI_Sum_test/test_scripts/./r4_processing_iri.sh /data4/afsisdata/IRI_Sum_test/test_scripts /data4/afsisdata/IRI_Sum_test/ndvi_update NDVI Feb 2000 Dec 2012 sinsusoidalKP tempKP

#call the script > input directory > output directory > dataset name > start month > start year > end month > end year > grass location > grass mapset

InputDir=$1
OutputDir=$2
DatasetName=$3
StartMonth=$4
StartYear=$5
EndMonth=$6
EndYear=$7
location=$8
mapset=$9

DatasetRes=250
DatasetRow=4800
DatasetCol=4800
FileType=Float32

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

echo
echo
echo Do you want to download the binary r4 raw files for $DatasetName from the IRI Data Library? [y/n] 
read answer
if [ $answer == "y" ]; then
	#downloading the raw data from IRI Data library
	/data4/afsisdata/IRI_Sum_test/test_scripts/./get_data_from_IRI.sh $DatasetName $DatasetRes $StartMonth $StartYear $EndMonth $EndYear $InputDir
elif [ $answer == "n" ]; then
	echo you have chosen not to download the r4 binary files
fi
#downloading the text file containing the number of observations
curl http://iridl.ldeo.columbia.edu/expert/home/.benno/.USGS/.landdaac/.$IriRes/.$DatasetName/T/%28"$StartMonth"%20"$StartYear"%29%28"$EndMonth"%20"$EndYear"%29RANGE/T/.npts/ -o $InputDir/"get_IRI_Npts_$DatasetName.txt"

#####################################EXTRACTING THE TOTAL NUMBER OF OBSERVATIONS
#This section calls the update text file containing the number of observations given the time range inputted when the script was called
h=1
for newString in $(cat $InputDir/get_IRI_Npts_$DatasetName.txt); do
	arrObs[$h]=$newString
	h=$((h+1))
done
lenArrObs=${#arrObs[@]}

i=1
while [ $i -lt $lenArrObs ]
do
	if [ ${arrObs[$i]} == "<li>" ]; then
		num=${arrObs[$i+1]}
	fi
	i=$((i+1))
done
NumObs=$(echo $num | sed 's/<.*//')
echo total number of observations: $NumObs

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

###############################################IMPORTING BINARIES AND EXPORTING GEOTIFFS FOR EACH TILE
#Assiging tile names and X/Y center points for the IRI Data Library
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
	
	#######################################IMPORTING INTO GRASS GIS
	
	#Imports r4 binary files of the tiles containing the average calculated by the IRI Data Library
	echo "$DatasetName"_avgIRI_"$StartMonth""$StartYear"_"$EndMonth""$EndYear"_"$eachTile1"_"$eachTile2".r4
	#import the binary files of calculated averages performed by the IRI Data Library
	r.in.bin -f -s -b --overwrite input=$InputDir/"$DatasetName"_avgIRI_"$StartMonth""$StartYear"_"$EndMonth""$EndYear"_"$eachTile1"_"$eachTile2".r4 output="$DatasetName"_avgIRI_"$StartMonth""$StartYear"_"$EndMonth""$EndYear"_"$eachTile1"_"$eachTile2" bytes=4 north=${Top[$eachTile2-2]} south=${Bottom[$eachTile2-2]} east=${Right[$eachTile1-2]} west=${Left[$eachTile1-2]} rows=$DatasetCol cols=$DatasetCol anull=NaN 

	#######################################EXPORTING GEOTIFFS OF FILES TO DIRECTOR ON SERVER

	#Geotiff outputs for each tile containing the time series average performed by the IRI Data Library
	r.out.gdal input="$DatasetName"_avgIRI_"$StartMonth""$StartYear"_"$EndMonth""$EndYear"_"$eachTile1"_"$eachTile2"@"$mapset" type=$FileType output=$OutputDir/"$DatasetName"_avgIRI_"$StartMonth""$StartYear"_"$EndMonth""$EndYear"_"$eachTile1"_"$eachTile2".tif
	chmod 775 $OutputDir/"$DatasetName"_avgIRI_"$StartMonth""$StartYear"_"$EndMonth""$EndYear"_"$eachTile1"_"$eachTile2".tif

	#######################################REMOVING TEMPORARY FILES IN GRASS GIS
	#removes the temporary tile layers
#	g.remove rast="$DatasetName"_avgIRI_"$StartMonth""$StartYear"_"$EndMonth""$EndYear"_"$eachTile1"_"$eachTile2"@"$mapset"
    done
done 

########################################MOSAICKING AND REPROJECTING TO LAMBERT, EXPORT TO DIRECTORY ON SERVER
cd $OutputDir
#list all tif in directory
tiflist=$(ls "$DatasetName"_avgIRI_"$StartMonth""$StartYear"_"$EndMonth""$EndYear"*.tif|grep -v "mosaic")
echo $tiflist
#mosaic all images in tiflist
time gdal_merge.py -n NaN -of GTiff -o $OutputDir/"$DatasetName"_avgIRI_"$StartMonth""$StartYear"_"$EndMonth""$EndYear"'_mosaic.tif' $tiflist

#reproject using gdal-option 1 (esp useful if grid in not in grass database) -- to remove 250x250 and leave at orig res take out: -tr $DatasetRes $DatasetRes, and remove '250' from $OutputDir/$DatasetName'_250mosaicLAEA.tif'
time gdalwarp -overwrite -s_srs '+proj=sinu +lon_0=0 +x_0=0 +y_0=0 +a=6371007.181 +b=6371007.181 +units=m +no_defs' -t_srs '+proj=laea +lat_0=5 +lon_0=20 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs' $OutputDir/"$DatasetName"_avgIRI_"$StartMonth""$StartYear"_"$EndMonth""$EndYear"'_mosaic.tif' $OutputDir/"$DatasetName"_avgIRI_"$StartMonth""$StartYear"_"$EndMonth""$EndYear"'_mosaicLAEA.tif' -multi -wm 5000

#changes the permissions for the calculated average and sum
chmod 775 $OutputDir/"$DatasetName"_avgIRI_"$StartMonth""$StartYear"_"$EndMonth""$EndYear"'_mosaicLAEA.tif'


##############################################################################
# remove internal tmp stuff:
$GISBASE/etc/clean_temp  || error_routine "clean_temp"
rm -rf $TMPDIR/grass6-$USER-$GIS_LOCK
