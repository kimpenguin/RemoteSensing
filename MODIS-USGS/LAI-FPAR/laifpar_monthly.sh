#!/bin/bash
#laifpar_monthly.sh
#written by Kimberly Peng
#date created: October 2015
#creates time series monthly average of 1000m lai and fpar

#/data4/afsisdata/USGS_updates/scripts/./laifpar_monthly.sh /data1/afsisdata/MODIS/LAI_FPAR_MCD15A2/Fpar MCD15A2 Fpar Geographic mcd15a2Fpar

#Parameters
InputDir=$1
NasaCode=$2
DatasetName=$3
Location=$4
Mapset=$5

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
mkdir /data3/grassdata/$Location/$Mapset
cp /data3/grassdata/$Location/PERMANENT/WIND /data3/grassdata/$Location/$Mapset

# generate GRASS settings file:
# the file contains the GRASS variables which define the LOCATION etc.
echo "GISDBASE: /data3/grassdata
LOCATION_NAME: $Location 
MAPSET: $Mapset
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
g.gisenv -n

#specify g.region based gdalinfo stats on one of the continent mosaics
g.region rast=2002.07.04.Fpar_1km@mcd15a2Fpar
#####

#####CREATE TIME SERIES MONTHLY AVERAGE

cd $InputDir
OutputDir=$InputDir/output
mkdir $OutputDir
months="01 02 03 04 05 06 07 08 09 10 11 12"

time for eachMonth in $months
do
	echo $eachMonth
    list=$(ls | grep "^.....$eachMonth")
	rslist=$(echo $list | sed "s/ /,/g;s/.tif/@"$Mapset"/g")
	echo $rslist

	#performs r.series based on dataset name
	if [ $DatasetName == "Fpar" ] ; then
		r.series input=$rslist output=FprAverage_"$eachMonth"@"$Mapset" method=average

		#fill null values with zero
		r.null map=FprAverage_"$eachMonth"@"$Mapset" null=0

		if [ $NasaCode == "MCD15A2" ]; then
			#import fill value file
			#fill raster was created using r.null and setting the null values to 0-248
			#the fill values will be restored before output
			r.in.gdal input=/data4/afsisdata/USGS_updates/laifpar/fill_value_rasters/geographic/MCD15A2_Fpar_2002_2014_AvgFills.tif output=MCD15A2_Fpar_2002_2014_AvgFills -e

			#restore the fill values 249-255
			r.mapcalculator amap=FprAverage_"$eachMonth"@"$Mapset" bmap='MCD15A2_Fpar_2002_2014_AvgFills@'$Mapset formula="if(A,A,A+B)" outfile="$NasaCode"_"$eachMonth"_FprAverage
		fi
		#exports to geotiff
		r.out.gdal input="$NasaCode"_"$eachMonth"_FprAverage@"$Mapset" output=$OutputDir/"$NasaCode"_"$DatasetName"_"$eachMonth"_'Average.tif' type=Float32 
	fi
done