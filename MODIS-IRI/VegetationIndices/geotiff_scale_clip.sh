#!/bin/bash
## This script will do the following depending on the dataset
## 1. Convert the data from Kelvin to Celsius degrees
## 2. Scale the data by a factor of 10000 to minimize the file size
## 3. Clip and export the data for the continent of Africa

##Primarily to be used for the AfSIS ftp site

# The user needs to input the following information to run the script
# 1. The input directory
# 2. The output directory
# 3. The data set name
# 4. Grass location
# 5. Grass mapset
# 6. File type

####################################################################
#Example: 
#r.series --overwrite input=2000.02.26.Fpar_1km@PERMANENT,2012.07.03.Fpar_1km@PERMANENT,2000.04.06.Fpar_1km@PERMANENT method=variance
####################################################################

#Input parameters: 
# /data4/afsisdata/IRI_MODIS/scripts/./geotiff_scale_clip.sh /data7/MODIS/200002-201509 laeaKPtemp modis

#bash scriptname.sh InputDirectory OutputDirectory DatasetName GrassLocation mapset Resolution ScaleFactor FileType
InputDir=$1
# OutputDir=$2
location=$2
mapset=$3
##############################################################################
#Start grass environment

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

#################################################################### SETTING THE MASK
#Import all the clip files to create a mask
# r.in.gdal -e input=/data4/AfSIS2tifs/SRTM/SRTM_AfricaClip_LAEA/SRTM_AfricaClip_250m_laea.tif output=SRTM_AfricaClip_250m_laea 
# r.in.gdal -e input=/data4/AfSIS2tifs/SRTM/SRTM_AfricaClip_LAEA/SRTM_AfricaClip_500m_laea.tif output=SRTM_AfricaClip_500m_laea
# r.in.gdal -e input=/data4/AfSIS2tifs/SRTM/SRTM_AfricaClip_LAEA/SRTM_AfricaClip_1000m_laea.tif output=SRTM_AfricaClip_1000m_laea
r.in.gdal -e input=/data4/GADM2/201509/gadm2_africa_250m.tif output=gadm2_africa_250m 
# r.in.gdal -e input=/data4/AfSIS2tifs/GADM/GADMv2/clips_laea/2015/gadm2_africaMask_500m.tif output=gadm2_africaMask_500m
r.in.gdal -e input=/data4/GADM2/201509/gadm2_africa_1000m.tif output=gadm2_africa_1000m
######
cd $InputDir
OutputDir=$InputDir/clipped
mkdir $OutputDir

# contains a list of all files in input directory
list=$(ls *.tif)
echo $list

time for file in ${list[*]}
do 
	echo $file
	file0=${file/\.tif/}  #take out the .tif from name
	name=$(echo $file | cut -d _ -f 1)
	echo $name

	echo Importing files into GRASS
	r.in.gdal -e input=$InputDir/$file output=$file0

	#If the data set is LST, then performs a degree conversion from Kelvin to celsius (Kelvin-273.15)
	if [ "$name" == "LST" ] || [ "$name" == "LSTD" ]|| [ "$name" == "LSTN" ]; then
		g.region rast=gadm2_africa_1000m
		r.mask -o input=gadm2_africa_1000m
		#celsius conversion
		r.mapcalculator formula="$file0"-273.15 outfile="$file0"_celsius
		#exporting the celsius file
		echo r.out.gdal input="$file0"_celsius type=Float32 output=$OutputDir/"$file0"_celsius.tif 
		r.out.gdal input="$file0"_celsius type=Float32 output=$OutputDir/"$file0"_celsius.tif 
		chmod 775 $OutputDir/"$file0"_celsius.tif
	else
		g.region rast=gadm2_africa_250m
		r.mask -o input=gadm2_africa_250m
		r.mapcalculator formula="$file0"*10000 outfile="$file0"_x10000
		#exports the layer
		echo r.out.gdal input="$file0"_x10000 type=Int16 output=$OutputDir/"$file0"_x10000.tif
		r.out.gdal input="$file0"_x10000 type=Int16 output=$OutputDir/"$file0"_x10000.tif 
		#removes layers from your mapset
		#g.remove rast="$file0"_celsius@"$mapset","$file0"_x10000@"$mapset"
	
		#changes permission on the exported file
		chmod 775 $OutputDir/"$file0"_x10000.tif
	fi

done
