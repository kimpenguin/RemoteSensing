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
#/data4/afsisdata/IRI_Sum_test/test_scripts/./geotiff_clipping_scalingLAEA.sh /data1/afsisdata/MODIS/Evi/evi_2000_2013/evi_2000_2013_monthlyMosaics/test/laea /data1/afsisdata/MODIS/Evi/evi_2000_2013/evi_2000_2013_monthlyMosaics/test/laea/clipped EVI laeaKPtemp evitest
#/data4/afsisdata/IRI_Sum_test/test_scripts/./geotiff_clipping_scalingLAEA.sh /data1/afsisdata/MODIS/Ndvi/ndvi_2000_2013/monthlyMosaics/test/laea /data1/afsisdata/MODIS/Ndvi/ndvi_2000_2013/monthlyMosaics/test/laea/clipped NDVI laeaKPtemp ndvi20140122
#/data4/afsisdata/IRI_Sum_test/test_scripts/./geotiff_clipping_scalingLAEA.sh /data1/afsisdata/MODIS/LstDay/lstd_2000_2013/monthlyMosaics/test/laea /data1/afsisdata/MODIS/LstDay/lstd_2000_2013/monthlyMosaics/test/laea/clipped LST_Day_1km laeaKPtemp lstKP20140123
#/data4/afsisdata/IRI_Sum_test/test_scripts/./geotiff_clipping_scalingLAEA.sh /data1/afsisdata/MODIS/LstNight/lstnight_2002_2013/monthlyMosaics/test/laea /data1/afsisdata/MODIS/LstNight/lstnight_2002_2013/monthlyMosaics/test/laea/clipped LST_Night_1km laeaKPtemp lstKP20140123

#bash scriptname.sh InputDirectory OutputDirectory DatasetName GrassLocation mapset Resolution ScaleFactor FileType

InputDir=$1
OutputDir=$2
DatasetName=$3
location=$4
mapset=$5



#conditional statement reassigns the correct IRI Data Library name for the requested data set.
if [ "$DatasetName" == "evi" ] || [ "$DatasetName" == "EVI" ]; then
	DatasetName=EVI
	Resolution=250m
elif [ "$DatasetName" == "ndvi" ] || [ "$DatasetName" == "NDVI" ]; then
	DatasetName=NDVI
	Resolution=250m
elif [ "$DatasetName" == "blue" ] || [ "$DatasetName" == "reflectance_blue" ]; then
	DatasetName=reflectance_blue
	Resolution=250m
elif [ "$DatasetName" == "red" ] || [ "$DatasetName" == "reflectance_red" ]; then
	DatasetName=reflectance_red
	Resolution=250m
elif [ "$DatasetName" == "mir" ] || [ "$DatasetName" == "MIR" ] || [ "$DatasetName" == "reflectance_MIR" ]; then
	DatasetName=reflectance_MIR
	Resolution=250m
elif [ "$DatasetName" == "nir" ] || [ "$DatasetName" == "NIR" ] || [ "$DatasetName" == "reflectance_NIR" ]; then
	DatasetName=reflectance_NIR
	Resolution=250m
elif [ "$DatasetName" == "lst_day" ] || [ "$DatasetName" == "LST_Day_1km" ]; then
	DatasetName=LST_Day_1km
	Resolution=1000m
elif [ "$DatasetName" == "lst_night" ] || [ "$DatasetName" == "LST_Night_1km" ]; then
	DatasetName=LST_Night_1km
	Resolution=1000m
fi        
    

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
r.in.gdal -e input=/data4/AfSIS2tifs/SRTM/SRTM_AfricaClip_LAEA/SRTM_AfricaClip_250m_laea.tif output=SRTM_AfricaClip_250m_laea 
r.in.gdal -e input=/data4/AfSIS2tifs/SRTM/SRTM_AfricaClip_LAEA/SRTM_AfricaClip_500m_laea.tif output=SRTM_AfricaClip_500m_laea
r.in.gdal -e input=/data4/AfSIS2tifs/SRTM/SRTM_AfricaClip_LAEA/SRTM_AfricaClip_1000m_laea.tif output=SRTM_AfricaClip_1000m_laea

#Setting the correct mask
r.mask -o input=SRTM_AfricaClip_"$Resolution"_laea

#################################################################### RESETTING G.REGION
#Setting the g.region according to the dataset

g.region rast=SRTM_AfricaClip_"$Resolution"_laea

cd $InputDir
list=$(ls $DatasetName*)
len=$(ls -1 $DatasetName*| wc )    #swap in count of total number of grids

echo $list
#################################################################### SCALING, CALCULATION, AND EXPORTING CLIPPED

#Import grids into grass as a loop for all the grids in a directory
time for file in ${list[*]}
do 
	echo $file
	file0=${file/\.tif/}  #take out the .tif from name
	echo Importing files into GRASS
	r.in.gdal -e input=$InputDir/$file output=$file0

	#If the data set is LST, then performs a degree conversion from Kelvin to celsius (Kelvin-273.15)
	if [ "$DatasetName" == "LST_Day_1km" ] || [ "$DatasetName" == "LST_Night_1km" ]; then
		#celsius conversion
		r.mapcalculator formula="$file0"-273.15 outfile="$file0"_celsius
		#exporting the celsius file
		echo r.out.gdal input="$file0"_celsius type=Float32 output=$OutputDir/"$file0"_celsius.tif 
		r.out.gdal input="$file0"_celsius type=Float32 output=$OutputDir/"$file0"_celsius.tif 
		chmod 775 $OutputDir/"$file0"_celsius.tif
	fi

	#Performs a raster calculation on the layer if the data set is 250m resolution
	if [ "$Resolution" == 250m ]; then
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



#if you want to remove input grids when calculations are completed-
#while IFS= read file; do
#g.remove rast="$file"@"$mapset"
#done < <(g.mlist type=rast mapset=$mapset)

####################################################################

# remove internal tmp stuff:
#$GISBASE/etc/clean_temp  || error_routine "clean_temp"
#rm -rf $TMPDIR/grass6-$USER-$GIS_LOCK
#cd /data3/grassdata/$location/
#rm -r $mapset
