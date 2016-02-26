#!/bin/bash
#laifpar_mosaic.sh
##Create mosaics from MODIS imagery downloaded from USGS ftp site, import and calculate averages in grass
#Written by Sonya Ahamed
#edited by Kimberly Peng

#Sample Commands:
#/data4/afsisdata/USGS_updates/scripts/./laifpar_mosaic.sh /data4/afsisdata/USGS_updates/laifpar/MOD15A2.005
#/data4/afsisdata/USGS_updates/scripts/./laifpar_mosaic.sh /data4/afsisdata/USGS_updates/laifpar/MCD15A2.005 

#Parameters
InputDir=$1
OutputDir=$InputDir/africa
mkdir $OutputDir

#loop over all folders in MOD15A2
for i in $InputDir/* ; do
    if [ -d "$i" ]; then
    baseDir=$i
    echo $i
    cd $baseDir
    rm TmpMosaic.prm

    #list hdf headers and store into TmpMosaic.prm
    for file in *.hdf
    do
        printf "$baseDir/$file \n" >> TmpMosaic.prm
        echo $file
    done

    #run mrtmosaic to mosaic all tiles together
    cd
    mrtmosaic -i $baseDir/TmpMosaic.prm -s "1 1 0 0 1 1" -o $baseDir/TmpMosaic.hdf
    cd $baseDir
    rm mrt.prm

    #write parameter file for each year (mosaicking all the tiles for that year), using geographic projection
    printf "INPUT_FILENAME = "$baseDir"/TmpMosaic.hdf \n 
    SPECTRAL_SUBSET = ( 1 1 0 0 1 1) \n 
    SPATIAL_SUBSET_TYPE = INPUT_LAT_LONG \n 
    SPATIAL_SUBSET_UL_CORNER = ( 39.999999996 -26.108145783 ) \n 
    SPATIAL_SUBSET_LR_CORNER = ( -39.999999996 78.324437349 ) \n 
    OUTPUT_FILENAME = "$OutputDir"/"${i##*/}".tif \n
    RESAMPLING_TYPE = NEAREST_NEIGHBOR \n
    OUTPUT_PROJECTION_TYPE = GEO \n
    OUTPUT_PROJECTION_PARAMETERS = ( \n
    0.0 0.0 0.0 \n
    0.0 0.0 0.0\n
    0.0 0.0 0.0\n
    0.0 0.0 0.0\n
    0.0 0.0 0.0 )\n
    DATUM = WGS84\n" >> mrt.prm

    #resample mosaic?
    cd
    resample -p $baseDir/mrt.prm
    rm $baseDir/TmpMosaic.hdf
    fi
done