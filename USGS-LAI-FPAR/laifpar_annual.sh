#!/bin/bash

#/data4/afsisdata/USGS_updates/scripts/./laifpar_annual.sh /data1/afsisdata/MODIS/LAI_FPAR_MCD15A2/Fpar MCD15A2 Fpar Geographic mcd15a2Fpar
#/data4/afsisdata/USGS_updates/scripts/./laifpar_annual.sh /data1/afsisdata/MODIS/LAI_FPAR_MOD15A2/Fpar MOD15A2 Fpar Geographic mod15a2Fpar

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

######EXTRACT START AND END YEAR

cd $InputDir
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

# echo $list
####################################################################
#specify g.region based gdalinfo stats on one of the continent mosaics
g.region -p n=39:59:59.999986N s=40:00:00.460219S e=78:19:31.27594E w=26:06:29.324819W rows=9600 cols=12532 res=0:00:30.000048

OutputDir=$InputDir/output
mkdir $OutputDir

i=$StartYear
while [ $i -le $EndYear ]
do
	echo current year is $i
	yearlist=$(ls $i*)
	echo $yearlist
	time for file in $yearlist
	do
	    echo $file
	    r.in.gdal input=$InputDir/$file output=${file/\.tif/} -e  #take out the .tif from name
	    g.region rast=${file/\.tif/}@$Mapset
	    # removes the fill values - will restore before export
	    r.null map=${file/\.tif/}@$Mapset setnull=249-255 
	done

	#performs r.series based on dataset name
	if [ $DatasetName == "Fpar" ] ; then
		rslist=$(echo $yearlist | sed "s/ /,/g;s/.tif/@"$Mapset"/g")
		r.series input=$rslist output=FprAverage_"$i"@"$Mapset" method=average

		#fill null values with zero
		r.null map=FprAverage_"$i"@"$Mapset" null=0

		if [ $NasaCode == "MCD15A2" ]; then
			#import fill value file
			r.in.gdal input=/data4/afsisdata/USGS_updates/laifpar/fill_value_rasters/geographic/MCD15A2_Fpar_2002_2014_AvgFills.tif output=MCD15A2_Fpar_2002_2014_AvgFills -e

			#restore the fill values 249-255
			r.mapcalculator amap=FprAverage_"$i"@"$Mapset" bmap='MCD15A2_Fpar_2002_2014_AvgFills@'$Mapset formula="if(A,A,A+B)" outfile="$NasaCode"_"$i"_'FprAverage'
		fi
		if [ $NasaCode == "MOD15A2" ]; then
			#import fill value file
			r.in.gdal input=/data4/afsisdata/USGS_updates/laifpar/fill_value_rasters/geographic/MOD15A2_Fpar_2000_2014_AvgFills.tif output=MOD15A2_Fpar_2000_2014_AvgFills -e

			#restore the fill values 249-255
			r.mapcalculator amap=FprAverage_"$i"@"$Mapset" bmap='MOD15A2_Fpar_2000_2014_AvgFills@'$Mapset formula="if(A,A,A+B)" outfile="$NasaCode"_"$i"_'FprAverage'
		fi
		
		#exports to geotiff
		r.out.gdal input="$NasaCode"_"$i"_'FprAverage@'$Mapset output=$OutputDir/"$NasaCode"_"$DatasetName"_"$i"_'Average.tif' type=Float32 
	fi
	i=$((i+1))
done
