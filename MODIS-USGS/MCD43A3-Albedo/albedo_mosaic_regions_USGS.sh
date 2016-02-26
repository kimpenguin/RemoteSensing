#!/bin/bash
##albedo_mosaic_regions_USGS.sh
##Creates a mosaic for West, East, and South Africa using the MODIS Reprojection Tool. OUtputs are GeoTiffs of each region. This script is to be run before albedo_mosaic_Africa_USGS.sh
#Written by Sonya Ahamed, modified by Kimberly Peng

#Sample Command:
#/data4/afsisdata/USGS_updates/scripts/./albedo_mosaic_regions_USGS.sh /data4/afsisdata/USGS_updates/albedo/MCD43A3.005 /data4/afsisdata/USGS_updates/albedo/outputs Albedo_BSA_Band_vis

#Parameters
InputDir=$1
OutputDir=$2
BandName=$3

#sets the band parameters for the modis reprojection tool
if [ $BandName == "Albedo_BSA_Band_vis" ]; then
	albedoband="0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0"
elif [ $BandName == "Albedo_BSA_Band_nir" ]; then
	albedoband="0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0"
elif [ $BandName == "Albedo_BSA_Band_shortwave" ]; then
	albedoband="0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0"
elif [ $BandName == "Albedo_WSA_Band_vis" ]; then
	albedoband="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0"
elif [ $BandName == "Albedo_WSA_Band_nir" ]; then
	albedoband="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0"
elif [ $BandName == "Albedo_WSA_Band_shortwave" ]; then
	albedoband="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1"
fi

##########################################################
#assigns tiles within each region (West, East, South) in Africa
MosaicWest=(h16v06 h16v07 h16v08 h17v05 h17v06 h17v07 h17v08 h18v05 h18v06 h18v07 h18v08 h19v05 h19v06 h19v07 h19v08)
MosaicEast=(h20v05 h20v06 h20v07 h20v08 h21v06 h21v07 h21v08 h22v07 h22v08 h23v07 h23v08)
MosaicSouth=(h18v09 h19v09 h19v10 h19v11 h19v12 h20v09 h20v10 h20v11 h20v12 h21v09 h21v10 h21v11 h22v09 h22v10 h22v11 )

##########################################################
#loop over the regions
########WEST
#loop over all folders in directory
for i in $InputDir/* ; do
	if [ -d "$i" ]; then

		baseDir=$i #baseDir loops through all the dates
		echo $i
		cd $baseDir
		rm TmpMosaicWest.prm
		#ls *.tif | xargs rm -rf {}  Uncomment this line if you want to remove all of the tifs in the directory first!
		ls *.prm | xargs rm -rf {}
		rm $baseDir/TmpMosaicWest.hdf

		#list hdf headers and store into TmpMosaic.prm
		for eachTile in ${MosaicWest[*]}
		do
			echo $eachTile
			ls $baseDir|grep $eachTile > tileName
			tileFile=`grep hdf$ tileName`	
			#statement ignores the tiles that are missing for the observation
			if [ "$tileFile" == "" ]; then
				echo ignoring missing tile
			else
				printf "$baseDir/$tileFile \n" >> TmpMosaicWest.prm
			fi
			
		done

	   	echo TmpMosaicWest.prm
		
		#run mrtmosaic to mosaic all tiles together
		cd
		mrtmosaic -i $baseDir/TmpMosaicWest.prm -s "$albedoband" -o $baseDir/TmpMosaicWest.hdf

		cd $baseDir
		rm mrtWest.prm

    #write parameter file for each year (mosaicking all the tiles for that year), using geographic projection
    printf "INPUT_FILENAME = "$baseDir"/TmpMosaicWest.hdf \n 
    SPECTRAL_SUBSET = ( 1 ) \n 
    SPATIAL_SUBSET_TYPE = INPUT_LAT_LONG \n 
    SPATIAL_SUBSET_UL_CORNER = ( 39.999999996 -26.108145783 ) \n 
    SPATIAL_SUBSET_LR_CORNER = ( -0.00 20.00 ) \n 
    OUTPUT_FILENAME = "$OutputDir"/"${i##*/}"West.tif \n  
    RESAMPLING_TYPE = NEAREST_NEIGHBOR \n
    OUTPUT_PROJECTION_TYPE = SIN \n
    OUTPUT_PROJECTION_PARAMETERS = ( \n
    6371007.18 0.0 0.0 \n
    0.0 0.0 0.0\n
    0.0 0.0 0.0\n
    0.0 0.0 0.0\n
    0.0 0.0 0.0 )\n
    DATUM = NoDatum\n" >> mrtWest.prm

		#resample mosaic?
		cd
		resample -p $baseDir/mrtWest.prm
		rm $baseDir/TmpMosaicWest.hdf
	fi
done

##########EAST
#loop over all folders in directory
for i in $InputDir/* ; do
	if [ -d "$i" ]; then
		baseDir=$i #baseDir loops through all the dates
		echo $i
		cd $baseDir
		ls *.prm | xargs rm -rf {}
		rm $baseDir/TmpMosaicEast.hdf
		#list hdf headers and store into TmpMosaic.prm
		for eachTile in ${MosaicEast[*]}
		do
			echo $eachTile
			ls $baseDir|grep $eachTile > tileName
			tileFile=`grep hdf$ tileName`
			#statement ignores the tiles that are missing for the observation
			if [ "$tileFile" == "" ]; then
				echo ignoring missing tile
			else
				printf "$baseDir/$tileFile \n" >> TmpMosaicEast.prm
			fi
		done

		echo TmpMosaicEast.prm
	    
		#run mrtmosaic to mosaic all tiles together
	    	cd
		mrtmosaic -i $baseDir/TmpMosaicEast.prm -s "$albedoband" -o $baseDir/TmpMosaicEast.hdf
		cd $baseDir
		rm mrtEast.prm

    #write parameter file for each year (mosaicking all the tiles for that year), using geographic projection
    printf "INPUT_FILENAME = "$baseDir"/TmpMosaicEast.hdf \n 
    SPECTRAL_SUBSET = ( 1 ) \n 
    SPATIAL_SUBSET_TYPE = INPUT_LAT_LONG \n 
    SPATIAL_SUBSET_UL_CORNER = ( 39.999999996 26.108145783 ) \n 
    SPATIAL_SUBSET_LR_CORNER = ( -0.00 59.999999995 ) \n 
    OUTPUT_FILENAME = "$OutputDir"/"${i##*/}"East.tif \n
    RESAMPLING_TYPE = NEAREST_NEIGHBOR \n
    OUTPUT_PROJECTION_TYPE = SIN \n
    OUTPUT_PROJECTION_PARAMETERS = ( \n
    6371007.18 0.0 0.0 \n
    0.0 0.0 0.0\n
    0.0 0.0 0.0\n
    0.0 0.0 0.0\n
    0.0 0.0 0.0 )\n
    DATUM = NoDatum\n" >> mrtEast.prm

		#resample mosaic?
		cd
		resample -p $baseDir/mrtEast.prm
		rm $baseDir/TmpMosaicEast.hdf
	fi
done

#######SOUTH
# #loop over all folders in directory
for i in $InputDir/* ; do
	if [ -d "$i" ]; then
		baseDir=$i #baseDir loops through all the dates
		echo $i
		cd $baseDir
	   
		ls *.prm | xargs rm -rf {}
		rm $baseDir/TmpMosaicSouth.hdf

		#list hdf headers and store into TmpMosaic.prm
		for eachTile in ${MosaicSouth[*]}
		do
			ls $baseDir|grep $eachTile > tileName
			tileFile=`grep hdf$ tileName`
			#statement ignores the tiles that are missing for the observation
			if [ "$tileFile" == "" ]; then
				echo ignoring missing tile
			else
				printf "$baseDir/$tileFile \n" >> TmpMosaicSouth.prm
			fi	
		done

		echo TmpMosaicSouth.prm
		#run mrtmosaic to mosaic all tiles together
	    	cd
		mrtmosaic -i $baseDir/TmpMosaicSouth.prm -s "$albedoband" -o $baseDir/TmpMosaicSouth.hdf
		cd $baseDir
		rm mrtSouth.prm

    #write parameter file for each year (mosaicking all the tiles for that year), using geographic projection
    printf "INPUT_FILENAME = "$baseDir"/TmpMosaicSouth.hdf \n 
    SPECTRAL_SUBSET = ( 1 ) \n 
    SPATIAL_SUBSET_TYPE = INPUT_LAT_LONG \n 
    SPATIAL_SUBSET_UL_CORNER = ( -0.0 -0.0 ) \n 
    SPATIAL_SUBSET_LR_CORNER = ( -39.999999996 78.324437349 ) \n 
    OUTPUT_FILENAME = "$OutputDir"/"${i##*/}"South.tif \n
    RESAMPLING_TYPE = NEAREST_NEIGHBOR \n
    OUTPUT_PROJECTION_TYPE = SIN \n
    OUTPUT_PROJECTION_PARAMETERS = ( \n
    6371007.18 0.0 0.0 \n
    0.0 0.0 0.0\n
    0.0 0.0 0.0\n
    0.0 0.0 0.0\n
    0.0 0.0 0.0 )\n
    DATUM = NoDatum\n" >> mrtSouth.prm

		#resample mosaic?
		cd
		resample -p $baseDir/mrtSouth.prm
		rm $baseDir/TmpMosaicSouth.hdf
	fi
done
