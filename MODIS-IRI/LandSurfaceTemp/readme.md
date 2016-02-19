## This directory contains the BASH scripts used to process and develop the 1km Land Surface Temperature (LST) Day and Night remote sensing covariates for the Africa Soil Information Service (AfSIS). The raw data and initial processing was done using the IRI Data Library http://iridl.ldeo.columbia.edu/.

The data products include the following:
* Land Surface Temperature Day
* Land Surface Temperature Night

## BASH scripts for time series or annual averages
Run the scripts in the following order:</br>
1. **get_data_IRI_MODIS1km.sh** - Downloads MODIS data, mosaics, and reprojects from Sinusoidal to Lambert Azimuthal Equal Area (LAEA). </br>
2. **geotiff_scale_clip.sh** - Converts from Kelvin to Celsius degrees and clips for Africa. </br>


## BASH scripts for time series or annual monthly averages
Run the scripts in the following order:</br>
1. **get_mondata_IRI_MODIS1km.sh** - Downloads MODIS data, mosaics, and reprojects from Sinusoidal to Lambert Azimuthal Equal Area (LAEA). </br>
2. **geotiff_scale_clip.sh** - Converts from Kelvin to Celsius degrees and clips for Africa. </br>