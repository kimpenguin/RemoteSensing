#!/bin/bash
##albedo_mosaic_Africa_USGS.sh
##Mosaics the 3 regions of Africa into a continent-wide raster in geographic projection
#Written by Sonya Ahamed

#Sample Command:
#/data4/afsisdata/USGS_updates/scripts/./albedo_mosaic_Africa_USGS.sh /data4/afsisdata/USGS_updates/albedo/regions Albedo_BSA_vis

#Parameters
InputDir=$1
BandName=$2

#create output directory to store africa mosaics
OutputDir=$InputDir/africa
mkdir $OutputDir

#Change into Input Directory
cd $InputDir
#ls $InputDir |grep East > DateList

list=$(ls |grep East)
echo $list

time for file in ${list[*]} 
do
#extract date

	echo $file
	eachDate=${file/East\."$BandName"\.tif/}
#	input=$InputDirectory/$file output=${file/\.tif/}
	echo $eachDate  
	
	#mosaic regions to create Africa continent-wide map    
	gdal_merge.py -of GTiff -o $OutputDir/$eachDate"mosaic"$BandName".tif" $InputDir"/"$eachDate"West."$BandName".tif" $InputDir"/"$eachDate"South."$BandName".tif" $InputDir"/"$eachDate"East."$BandName".tif"
	chmod 775 $OutputDir/$eachDate"mosaic"$BandName".tif" 

done

