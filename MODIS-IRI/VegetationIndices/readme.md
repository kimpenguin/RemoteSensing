## This directory contains the BASH scripts used to create the MODIS Vegetation Indices for the Africa Soil Information Service (AfSIS). The raw data and initial processing was done using the IRI Data Library http://iridl.ldeo.columbia.edu/.

The data products include the following:
* Enhanced Vegetation Index (EVI)
* Normalized Difference Vegetation Index (NDVI)
* Reflectance Red Band 1
* Reflectance Near-Infrared (NIR) Band 2
* Reflectance Blue Band 3
* Reflectance Mid-Infrared (MIR) Band 7

## Example command in IRI DL Expert Mode
The following code creates a February average from all Feb observations from 2002-2015 for one tile in Africa. 
```
 expert
 SOURCES .USGS .LandDAAC .MODIS .250m .16day .EVI
  T (2002) (2015) RANGE
  T (Feb) VALUES
  X -1667928 VALUE
  Y 2779877 VALUE
  [T]average
```
link equivalent: http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.250m/.16day/.EVI/T/%282002%29%282015%29RANGE/T/%28Feb%29VALUES/X/-1667928/VALUE/Y/2779877/VALUE%5BT%5Daverage/#expert

## BASH scripts for time series or annual averages
Run the scripts in the following order:
1. **get_data_IRI_MODIS250m.sh** - Downloads MODIS data, mosaics, and reprojects to Lambert Azimuthal Equal Area (LAEA).
2. **geotiff_scale_clip.sh** - Multiplies MODIS by 10000 and clips for Africa.


## BASH scripts for time series or annual monthly averages
Run the scripts in the following order:
1. **get_mondata_IRI_MODIS250m.sh** - Downloads MODIS data, mosaics, and reprojects to Lambert Azimuthal Equal Area (LAEA).
2. **geotiff_scale_clip.sh** - Multiplies MODIS by 10000 and clips for Africa.

