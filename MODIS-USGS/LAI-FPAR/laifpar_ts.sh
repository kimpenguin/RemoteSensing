#!/bin/bash
##laifpar_geoprocessing.sh
##Written by Sonya Ahamed, modified by Kimberly Peng
##The script creates time series average, variance, and standard deviation for MOD15A2 and MCD15A2 products

#Sample Commands: 
#/data4/afsisdata/USGS_updates/scripts/./laifpar_geoprocessing.sh /data1/afsisdata/MODIS/LAI_FPAR_MCD15A2/Fpar MCD15A2 Fpar Geographic fparMCD2015
#/data4/afsisdata/USGS_updates/scripts/./laifpar_geoprocessing.sh /data1/afsisdata/MODIS/LAI_FPAR_MCD15A2/Lai MCD15A2 Lai Geographic laiMCD2015
#/data4/afsisdata/USGS_updates/scripts/./laifpar_geoprocessing.sh /data1/afsisdata/MODIS/LAI_FPAR_MOD15A2/Fpar MOD15A2 Fpar Geographic fparMOD2015
#/data4/afsisdata/USGS_updates/scripts/./laifpar_geoprocessing.sh /data1/afsisdata/MODIS/LAI_FPAR_MOD15A2/Lai MOD15A2 Lai Geographic laiMOD2015

#Parameters
InputDir=$1
NasaCode=$2
DatasetName=$3
location=$4
mapset=$5

echo $location
###########################Starting GRASS Environment
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
g.gisenv -n

####################################################################
cd $InputDir
#create output directory
OutputDir=$InputDir/outputs
mkdir $OutputDir

list=$(ls *$DatasetName*)
# len=$(ls -1 *$DatasetName*| wc )    #swap in count of total number of grids

arr=(`ls *$DatasetName*`) #creates an array to store all the filenames within the input directory
#echo ${arr[@]} #prints the entire array of filenames
numObs=${#arr[@]} #stores the total number of files contained within the input directory
echo total number of observations $numObs

firstObs=${arr[1]}
lastObs=${arr[$(($numObs-1))]}

StartYear=$(echo $firstObs | cut -c1-4)
echo start year is $StartYear
EndYear=$(echo $lastObs | cut -c1-4)
echo last year is $EndYear


echo $list
####################################################################
#specify g.region based gdalinfo stats on one of the continent mosaics
g.region n=39.999999995999978 s=-40.0001278 w=-26.108145782999991 e=78.3253544 rows=9600 cols=12532

#Import grids into grass as a loop for all the grids in a directory
time for file in ${list[*]}
do
    echo $file
    r.in.gdal input=$InputDir/$file output=${file/\.tif/} -e  #take out the .tif from name
    g.region rast=${file/\.tif/}@$mapset
    #removes the fill values - will restore before export
    r.null map=${file/\.tif/}@$mapset setnull=249-255 
done

#performs r.series based on dataset name
if [ $DatasetName == "Fpar" ] ; then
	r.series input="`g.mlist pattern='*Fpar*' sep=,`" output='FprAverage@'$mapset method=average
	r.series input="`g.mlist pattern='*Fpar*' sep=,`" output='FprVariance@'$mapset method=variance
	r.series input="`g.mlist pattern='*Fpar*' sep=,`" output='FprStdDev@'$mapset method=stddev

	#fill null values with zero
	r.null map='FprAverage@'$mapset null=0
	r.null map='FprVariance@'$mapset null=0
	r.null map='FprStdDev@'$mapset null=0

	if [ $NasaCode == "MCD15A2" ]; then
		#import fill value file
		r.in.gdal input=/data4/afsisdata/USGS_updates/laifpar/fill_value_rasters/geographic/MCD15A2_Fpar_2002_2014_AvgFills.tif output=MCD15A2_Fpar_2002_2014_AvgFills -e

		#restore the fill values 249-255
		r.mapcalculator amap='FprAverage@'$mapset bmap='MCD15A2_Fpar_2002_2014_AvgFills@'$mapset formula="if(A,A,A+B)" outfile="$NasaCode"_'FprAverage'
		r.mapcalculator amap='FprVariance@'$mapset bmap='MCD15A2_Fpar_2002_2014_AvgFills@'$mapset formula="if(A,A,A+B)" outfile="$NasaCode"_'FprVariance'
		r.mapcalculator amap='FprStdDev@'$mapset bmap='MCD15A2_Fpar_2002_2014_AvgFills@'$mapset formula="if(A,A,A+B)" outfile="$NasaCode"_'FprStdDev'	

	elif [ $NasaCode == "MOD15A2" ]; then
		#import fill value file
		r.in.gdal input=/data4/afsisdata/USGS_updates/laifpar/fill_value_rasters/geographic/MOD15A2_Fpar_2000_2014_AvgFills.tif output=MOD15A2_Fpar_2000_2014_AvgFills -e

		#restore the fill values 249-255
		r.mapcalculator amap='FprAverage@'$mapset bmap='MOD15A2_Fpar_2000_2014_AvgFills@'$mapset formula="if(A,A,A+B)" outfile="$NasaCode"_'FprAverage'
		r.mapcalculator amap='FprVariance@'$mapset bmap='MOD15A2_Fpar_2000_2014_AvgFills@'$mapset formula="if(A,A,A+B)" outfile="$NasaCode"_'FprVariance'
		r.mapcalculator amap='FprStdDev@'$mapset bmap='MOD15A2_Fpar_2000_2014_AvgFills@'$mapset formula="if(A,A,A+B)" outfile="$NasaCode"_'FprStdDev'	
	fi
	
	#exports to geotiff
	r.out.gdal input="$NasaCode"_'FprAverage@'$mapset output=$OutputDir/"$NasaCode"_"$DatasetName"_"$StartYear"_"$EndYear"_'Average.tif' type=Float32 
	r.out.gdal input="$NasaCode"_'FprVariance@'$mapset output=$OutputDir/"$NasaCode"_"$DatasetName"_"$StartYear"_"$EndYear"_'Variance.tif' type=Float32
	r.out.gdal input="$NasaCode"_'FprStdDev@'$mapset output=$OutputDir/"$NasaCode"_"$DatasetName"_"$StartYear"_"$EndYear"_'StdDev.tif' type=Float32
	

elif [ $DatasetName == "Lai" ]; then
	r.series input="`g.mlist pattern='*Lai*' sep=,`" output='LaiAverage@'$mapset method=average
	r.series input="`g.mlist pattern='*Lai*' sep=,`" output='LaiVariance@'$mapset method=variance
	r.series input="`g.mlist pattern='*Lai*' sep=,`" output='LaiStdDev@'$mapset method=stddev

	#fill null values with zero
	r.null map='LaiAverage@'$mapset null=0
	r.null map='LaiVariance@'$mapset null=0
	r.null map='LaiStdDev@'$mapset null=0

	if [ $NasaCode == "MCD15A2" ]; then
		#import fill value file
		r.in.gdal input=/data4/afsisdata/USGS_updates/laifpar/fill_value_rasters/geographic/MCD15A2_Lai_2002_2014_AvgFills.tif output=MCD15A2_Lai_2002_2014_AvgFills -e

		#restore the fill values 249-255
		r.mapcalculator amap='LaiAverage@'$mapset bmap='MCD15A2_Lai_2002_2014_AvgFills@'$mapset formula="if(A,A,A+B)" outfile="$NasaCode"_'LaiAverage'
		r.mapcalculator amap='LaiVariance@'$mapset bmap='MCD15A2_Lai_2002_2014_AvgFills@'$mapset formula="if(A,A,A+B)" outfile="$NasaCode"_'LaiVariance'
		r.mapcalculator amap='LaiStdDev@'$mapset bmap='MCD15A2_Lai_2002_2014_AvgFills@'$mapset formula="if(A,A,A+B)" outfile="$NasaCode"_'LaiStdDev'	

	elif [ $NasaCode == "MOD15A2" ]; then
		#import fill value file
		r.in.gdal input=/data4/afsisdata/USGS_updates/laifpar/fill_value_rasters/geographic/MOD15A2_Lai_2000_2014_AvgFills.tif output=MOD15A2_Lai_2000_2014_AvgFills -e

		#restore the fill values 249-255
		r.mapcalculator amap='LaiAverage@'$mapset bmap='MOD15A2_Lai_2000_2014_AvgFills@'$mapset formula="if(A,A,A+B)" outfile="$NasaCode"_'LaiAverage'
		r.mapcalculator amap='LaiVariance@'$mapset bmap='MOD15A2_Lai_2000_2014_AvgFills@'$mapset formula="if(A,A,A+B)" outfile="$NasaCode"_'LaiVariance'
		r.mapcalculator amap='LaiStdDev@'$mapset bmap='MOD15A2_Lai_2000_2014_AvgFills@'$mapset formula="if(A,A,A+B)" outfile="$NasaCode"_'LaiStdDev'	
	fi

	#exports to geotiff
	r.out.gdal input="$NasaCode"_'LaiAverage@'$mapset output=$OutputDir/"$NasaCode"_"$DatasetName"_"$StartYear"_"$EndYear"_'Average.tif' type=Float32 
	r.out.gdal input="$NasaCode"_'LaiVariance@'$mapset output=$OutputDir/"$NasaCode"_"$DatasetName"_"$StartYear"_"$EndYear"_'Variance.tif' type=Float32
	r.out.gdal input="$NasaCode"_'LaiStdDev@'$mapset output=$OutputDir/"$NasaCode"_"$DatasetName"_"$StartYear"_"$EndYear"_'StdDev.tif' type=Float32
fi

#if you want to remove input grids when calculations are completed-
#data=$(g.mlist type=rast pattern=$datasetName mapset=PERMANENT) 
#while read data
#do
#g.remove $data@PERMANENT
#done

####################################################################
####################################################################

# remove internal tmp stuff:
$GISBASE/etc/clean_temp  || error_routine "clean_temp"
rm -rf $TMPDIR/grass6-$USER-$GIS_LOCK
