#!/bin/bash
#get_mondata_IRI_MODIS1km.sh
#written by Kimberly Peng
# This scripts downloads the time series average for the Land surface temperature and creates an Africa mosaic reprojected to Lambert Azimuthal Equal Area.

#Examples:
#/data4/afsisdata/IRI_MODIS/scripts/./get_mondata_IRI_MODIS1km.sh LSTD Jul 2002 Sep 2015 /data7/MODIS/LSTD
#/data4/afsisdata/IRI_MODIS/scripts/./get_mondata_IRI_MODIS1km.sh LSTN Jul 2002 Sep 2015 /data7/MODIS/LSTN


#parameters
Dataset=$1
StartMonth=$2
StartYear=$3
EndMonth=$4
EndYear=$5
OutputDir=$6

InputDir=$OutputDir/inputs
mkdir $InputDir
months="Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"

for eachMonth in $months
do
	DatasetName="$Dataset"_avg_"$StartYear""$StartMonth"_"$EndYear""$EndMonth"
	if [ $Dataset == "LSTD" ]; then
	echo downloading EAF "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.1km/.8day/.version_005/.Aqua/.EAF/.Day/.LST/T/("$StartMonth"%20"$StartYear")/("$EndMonth"%20"$EndYear")/RANGE/T/("$eachMonth")/VALUES/%5BT%5D/average"
	curl "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.1km/.8day/.version_005/.Aqua/.EAF/.Day/.LST/T/("$StartMonth"%20"$StartYear")/("$EndMonth"%20"$EndYear")/RANGE/T/("$eachMonth")/VALUES/%5BT%5D/average/data.tiff?filename=data.tiff" -o $InputDir/"$DatasetName"_"$eachMonth"_EAF.tif


	echo downloading SAF "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.1km/.8day/.version_005/.Aqua/.SAF/.Day/.LST/T/("$StartMonth"%20"$StartYear")/("$EndMonth"%20"$EndYear")/RANGE/T/("$eachMonth")/VALUES/%5BT%5D/average"
	curl "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.1km/.8day/.version_005/.Aqua/.SAF/.Day/.LST/T/("$StartMonth"%20"$StartYear")/("$EndMonth"%20"$EndYear")/RANGE/T/("$eachMonth")/VALUES/%5BT%5D/average/data.tiff?filename=data.tiff" -o $InputDir/"$DatasetName"_"$eachMonth"_SAF.tif

	echo downloading WAF "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.1km/.8day/.version_005/.Aqua/.WAF/.Day/.LST/T/("$StartMonth"%20"$StartYear")/("$EndMonth"%20"$EndYear")/RANGE/T/("$eachMonth")/VALUES/%5BT%5D/average"
	curl "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.1km/.8day/.version_005/.Aqua/.WAF/.Day/.LST/T/("$StartMonth"%20"$StartYear")/("$EndMonth"%20"$EndYear")/RANGE/T/("$eachMonth")/VALUES/%5BT%5D/average/data.tiff?filename=data.tiff" -o $InputDir/"$DatasetName"_"$eachMonth"_WAF.tif
	fi

	if [ $Dataset == "LSTN" ]; then
	echo downloading EAF "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.1km/.8day/.version_005/.Aqua/.EAF/.Night/.LST/T/("$StartMonth"%20"$StartYear")/("$EndMonth"%20"$EndYear")/RANGE/T/("$eachMonth")/VALUES/%5BT%5D/average"
	curl "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.1km/.8day/.version_005/.Aqua/.EAF/.Night/.LST/T/("$StartMonth"%20"$StartYear")/("$EndMonth"%20"$EndYear")/RANGE/T/("$eachMonth")/VALUES/%5BT%5D/average/data.tiff?filename=data.tiff" -o $InputDir/"$DatasetName"_"$eachMonth"_EAF.tif


	echo downloading SAF "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.1km/.8day/.version_005/.Aqua/.SAF/.Night/.LST/T/("$StartMonth"%20"$StartYear")/("$EndMonth"%20"$EndYear")/RANGE/T/("$eachMonth")/VALUES/%5BT%5D/average"
	curl "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.1km/.8day/.version_005/.Aqua/.SAF/.Night/.LST/T/("$StartMonth"%20"$StartYear")/("$EndMonth"%20"$EndYear")/RANGE/T/("$eachMonth")/VALUES/%5BT%5D/average/data.tiff?filename=data.tiff" -o $InputDir/"$DatasetName"_"$eachMonth"_SAF.tif

	echo downloading WAF "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.1km/.8day/.version_005/.Aqua/.WAF/.Night/.LST/T/("$StartMonth"%20"$StartYear")/("$EndMonth"%20"$EndYear")/RANGE/T/("$eachMonth")/VALUES/%5BT%5D/average"
	curl "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.1km/.8day/.version_005/.Aqua/.WAF/.Night/.LST/T/("$StartMonth"%20"$StartYear")/("$EndMonth"%20"$EndYear")/RANGE/T/("$eachMonth")/VALUES/%5BT%5D/average/data.tiff?filename=data.tiff" -o $InputDir/"$DatasetName"_"$eachMonth"_WAF.tif
	fi

	# MOSAIC and REPROJECT
	cd $InputDir
	#list all tif in directory
	tiflist=$(ls "$DatasetName"_"$eachMonth"_*.tif|grep -v "mosaic")
	echo the list is: $tiflist
	#mosaic all images in tiflist
	time gdal_merge.py -n NaN -of GTiff -o $OutputDir/"$DatasetName"_"$eachMonth"'_mosaic.tif' $tiflist

	# reproject from Geographic to Lambert Azimuthal Equal Area
	time gdalwarp -overwrite -s_srs '+proj=longlat +datum=WGS84 +no_defs' -t_srs '+proj=laea +lat_0=5 +lon_0=20 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs' $OutputDir/"$DatasetName"_"$eachMonth"'_mosaic.tif' $OutputDir/"$DatasetName"_"$eachMonth"'_mosaicLAEA.tif' -multi -wm 5000
	chmod 775 $OutputDir/"$DatasetName"_"$eachMonth"'_mosaicLAEA.tif'

done

#remove inputs directory
rm -r $InputDir
