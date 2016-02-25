### This directory contains the BASH scripts used to create the MODIS Vegetation Indices for the Africa Soil Information Service (AfSIS). The raw data and initial processing was done using the IRI Data Library http://iridl.ldeo.columbia.edu/.

The data products include the following:
* Enhanced Vegetation Index (EVI)
* Normalized Difference Vegetation Index (NDVI)
* Reflectance Red Band 1
* Reflectance Near-Infrared (NIR) Band 2
* Reflectance Blue Band 3
* Reflectance Mid-Infrared (MIR) Band 7

### Example command in IRI DL Expert Mode
The following code creates a February average from all Feb observations from 2002-2015 for one tile in Africa. Check benno_grid for XY values for each tile and specific naming convention.
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

---
## Scripts
### 1. **get_data_IRI_MODIS250m.sh**
This script downloads and mosaics the time series average for the vegetation indices given a specific temporal range 

**Example command:**

```
/data4/afsisdata/IRI_MODIS/scripts/./get_data_IRI_MODIS250m.sh EVI Feb 2000 Jun 2015 /data7/MODIS/EVI sinusoidal modis
```

The script above will generate an Africa wide map of the time series average enhanced vegetation index (EVI) using all the observations from February 2000 - June 2015. The data will start in sinusoidal projection but will be mosaicked and reprojected to Lambert Azimuthal Equal Area (LAEA).

**Parameters:**

  1. Name of the data set that you would like to download. Below are the valid choices:
  	* EVI
  	* NDVI
  	* reflectance_red
  	* reflectance_NIR
  	* reflectance_blue
  	* reflectance_MIR
  	* In the example command, ``EVI``
  2. 3-letter abbreviation for the month that you would like to start downloading from. For example, if you wanted to start in January, use 'Jan'.
    * In the example command, ``Feb``
  3. The year that you would like to start downloading from
  	* The MODIS 250m data started in Feb 2000, so the first year you could enter is 2000.
  	* In the example command, ``2000``
  4. 3-letter abbreviation for the month that you would like to end on
  	* In the example command, ``Jun``
  5. The year that you would like end downloading
  	* In the example command, ``2015``
  6. Path of the directory in which outputs will be stored.
  	* Make sure this directory is created before you run the script!!!
  	* In the example command, ``/data7/MODIS/EVI``
  7. Name of the GRASS location you created in sinusoidal projection
    * You need to create a sinusoidal location before you run this script!
    * In the example command, ``sinusoidal``
  8. Name of a GRASS mapset that will be created within the script
  	* In the example command, ``modis``

**Outputs**

The time series average, **EVI_avgIRI_Feb2000_Jun2015_mosaicLAEA.tif**, will be located in a directory, **outputs**, which is created when the script ran.

---
### 2. **get_mondata_IRI_MODIS250m.sh**

**Example command:**

```
/data4/afsisdata/IRI_MODIS/scripts/./get_mondata_IRI_MODIS250m.sh EVI Feb 2000 Jun 2015 /data7/MODIS/EVI/monthly sinusoidalSA modis
```

The command above will create a time series average for each month, Jan-Dec, of the enhanced vegetation index (evi) using the available observations from Februrary 2000 - June 2015.

**Parameters:**

  1. Name of the data set that you would like to download. Below are the valid choices:
  	* EVI
  	* NDVI
  	* reflectance_red
  	* reflectance_NIR
  	* reflectance_blue
  	* reflectance_MIR
  	* In the example command, ``EVI``
  2. 3-letter abbreviation for the month that you would like to start downloading from. For example, if you wanted to start in January, use 'Jan'.
    * In the example command, ``Feb``
  3. The year that you would like to start downloading from
  	* The MODIS 250m data started in Feb 2000, so the first year you could enter is 2000.
  	* In the example command, ``2000``
  4. 3-letter abbreviation for the month that you would like to end on
  	* In the example command, ``Jun``
  5. The year that you would like end downloading
  	* In the example command, ``2015``
  6. Path of the directory in which outputs will be stored.
  	* Make sure this directory is created before you run the script!!!
  	* In the example command, ``/data7/MODIS/EVI``
  7. Name of the GRASS location you created in sinusoidal projection
    * You need to create a sinusoidal location before you run this script!
    * In the example command, ``sinusoidal``
  8. Name of a GRASS mapset that will be created within the script
  	* In the example command, ``modis``

**Outputs**

The time series averages for each month will be located in a directory, **outputs**, which is created when the script ran. For the example command, the outputs would appear **EVI_avgIRI_Feb2000_Jun2015_Jan_mosaicLAEA.tif**, **EVI_avgIRI_Feb2000_Jun2015_Feb_mosaicLAEA.tif**, ..., **EVI_avgIRI_Feb2000_Jun2015_Dec_mosaicLAEA.tif**.

