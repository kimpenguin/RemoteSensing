# This directory contains the BASH scripts used to create the MODIS Vegetation Indices for the Africa Soil Information Service (AfSIS).

The data products include the following:
* Enhanced Vegetation Index
* Normalized Difference Vegetation Index
* Reflectance Red Band 1
* Reflectance Near-Infrared (NIR) Band 2
* Reflectance Blue Band 3
* Reflectance Mid-Infrared (MIR) Band 7

## BASH scripts for time series or annual averages
1. **get_data_IRI_MODIS250m.sh** - Downloads MODIS data, mosaics, and reprojects to Lambert Azimuthal Equal Area (LAEA).
2. **geotiff_scale_clip.sh** - Multiplies MODIS by 10000 and clips for Africa.


## BASH scripts for time series or annual monthly averages
1. **get_mondata_IRI_MODIS250m.sh** - Downloads MODIS data, mosaics, and reprojects to Lambert Azimuthal Equal Area (LAEA).
2. **geotiff_scale_clip.sh** - Multiplies MODIS by 10000 and clips for Africa.

