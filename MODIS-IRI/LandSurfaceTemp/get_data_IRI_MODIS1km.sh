#!/bin/bash
#get_data_IRI_MODIS1km.sh
#written by Kimberly Peng
# This scripts downloads the time series average for the Land surface temperature and creates an Africa mosaic reprojected to Lambert Azimuthal Equal Area.

#Examples:
#/data4/afsisdata/IRI_MODIS/scripts/./get_data_IRI_MODIS1km.sh LSTD Jul 2002 Jun 2015 /data7/MODIS/LSTD
#/data4/afsisdata/IRI_MODIS/scripts/./get_data_IRI_MODIS1km.sh LSTN Jul 2002 Jun 2015 /data7/MODIS/LSTN


#parameters
Dataset=$1
Month1=$2
Year1=$3
Month2=$4
Year2=$5
OutputDir=$6

#create an input directory
InputDir=$OutputDir/inputs
mkdir $InputDir

if [ $Dataset == "LSTD" ]; then
echo downloading EAF "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.1km/.8day/.version_005/.Aqua/.EAF/.Day/.LST/T/%28"$Month1"%20"$Year1"%29%28"$Month2"%20"$Year2"%29RANGE%5BT%5Daverage/data.tiff?filename=data.tiff"

curl "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.1km/.8day/.version_005/.Aqua/.EAF/.Day/.LST/T/%28"$Month1"%20"$Year1"%29%28"$Month2"%20"$Year2"%29RANGE%5BT%5Daverage/data.tiff?filename=data.tiff" -o $InputDir/"$Dataset"_EAF_"$Month1""$Year1"_"$Month2""$Year2".tif

echo downloading SAF "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.1km/.8day/.version_005/.Aqua/.SAF/.Day/.LST/T/%28"$Month1"%20"$Year1"%29%28"$Month2"%20"$Year2"%29RANGE%5BT%5Daverage/data.tiff?filename=data.tiff"

curl "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.1km/.8day/.version_005/.Aqua/.SAF/.Day/.LST/T/%28"$Month1"%20"$Year1"%29%28"$Month2"%20"$Year2"%29RANGE%5BT%5Daverage/data.tiff?filename=data.tiff" -o $InputDir/"$Dataset"_SAF_"$Month1""$Year1"_"$Month2""$Year2".tif

echo downloading WAF "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.1km/.8day/.version_005/.Aqua/.WAF/.Day/.LST/T/%28"$Month1"%20"$Year1"%29%28"$Month2"%20"$Year2"%29RANGE%5BT%5Daverage/data.tiff?filename=data.tiff"

curl "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.1km/.8day/.version_005/.Aqua/.WAF/.Day/.LST/T/%28"$Month1"%20"$Year1"%29%28"$Month2"%20"$Year2"%29RANGE%5BT%5Daverage/data.tiff?filename=data.tiff" -o $InputDir/"$Dataset"_WAF_"$Month1""$Year1"_"$Month2""$Year2".tif
fi
if [ $Dataset == "LSTN" ]; then

echo downloading EAF "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.1km/.8day/.version_005/.Aqua/.EAF/.Night/.LST/T/%28"$Month1"%20"$Year1"%29%28"$Month2"%20"$Year2"%29RANGE%5BT%5Daverage/data.tiff?filename=data.tiff"

curl "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.1km/.8day/.version_005/.Aqua/.EAF/.Night/.LST/T/%28"$Month1"%20"$Year1"%29%28"$Month2"%20"$Year2"%29RANGE%5BT%5Daverage/data.tiff?filename=data.tiff" -o $InputDir/"$Dataset"_EAF_"$Month1""$Year1"_"$Month2""$Year2".tif

echo downloading SAF "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.1km/.8day/.version_005/.Aqua/.SAF/.Night/.LST/T/%28"$Month1"%20"$Year1"%29%28"$Month2"%20"$Year2"%29RANGE%5BT%5Daverage/data.tiff?filename=data.tiff"

curl "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.1km/.8day/.version_005/.Aqua/.SAF/.Night/.LST/T/%28"$Month1"%20"$Year1"%29%28"$Month2"%20"$Year2"%29RANGE%5BT%5Daverage/data.tiff?filename=data.tiff" -o $InputDir/"$Dataset"_SAF_"$Month1""$Year1"_"$Month2""$Year2".tif

echo downloading WAF "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.1km/.8day/.version_005/.Aqua/.WAF/.Night/.LST/T/%28"$Month1"%20"$Year1"%29%28"$Month2"%20"$Year2"%29RANGE%5BT%5Daverage/data.tiff?filename=data.tiff"

curl "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.1km/.8day/.version_005/.Aqua/.WAF/.Night/.LST/T/%28"$Month1"%20"$Year1"%29%28"$Month2"%20"$Year2"%29RANGE%5BT%5Daverage/data.tiff?filename=data.tiff" -o $InputDir/"$Dataset"_WAF_"$Month1""$Year1"_"$Month2""$Year2".tif
fi

# MOSAIC and REPROJECT
cd $InputDir
#list all tif in directory
tiflist=$(ls "$Dataset"_*.tif|grep -v "mosaic")
echo $tiflist
#mosaic all images in tiflist
time gdal_merge.py -n NaN -of GTiff -o $OutputDir/"$Dataset"_avgIRI_"$Month1""$Year1"_"$Month2""$Year2"'_mosaic.tif' $tiflist

# reproject from Geographic to Lambert Azimuthal Equal Area
time gdalwarp -overwrite -s_srs '+proj=longlat +datum=WGS84 +no_defs' -t_srs '+proj=laea +lat_0=5 +lon_0=20 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs' $OutputDir/"$Dataset"_avgIRI_"$Month1""$Year1"_"$Month2""$Year2"'_mosaic.tif' $OutputDir/"$Dataset"_avgIRI_"$Month1""$Year1"_"$Month2""$Year2"'_mosaicLAEA.tif' -multi -wm 5000

# #changes the permissions for the calculated average and sum
chmod 775 $OutputDir/"$Dataset"_avgIRI_"$Month1""$Year1"_"$Month2""$Year2"'_mosaicLAEA.tif'


#remove inputs directory
rm -r $InputDir


