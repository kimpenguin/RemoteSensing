### This directory contains the BASH scripts used to process and develop the 1km Land Surface Temperature (LST) Day and Night remote sensing covariates for the Africa Soil Information Service (AfSIS). The raw data and initial processing was done using the IRI Data Library http://iridl.ldeo.columbia.edu/.

The data products include the following:
* Land Surface Temperature Day
* Land Surface Temperature Night

## Scripts

### 1. get_data_IRI_MODIS1km.sh

This script creates an average for LST Day or LST Night depending on user specifications.

**Example command:**

```
/data4/afsisdata/IRI_MODIS/scripts/./get_data_IRI_MODIS1km.sh LSTD Jul 2002 Jun 2015 /data7/MODIS/LSTD
```

The command above downloads and mosaics for Africa the time series average for LST Day using all available LST Day observations from July 2002 - June 2015.

**Parameters**
  1. Data set that you would like to download. The following are valid entries for this parameter:
  	* LSTD
  	* LSTN
  	* In the example command, ``LSTD`` is used for LST Day
  2. 3-letter abbreviation for the month in which you would like to start the processing
  	* The first available observations for LST were in July 2002
  	* In the example command, ``Jul``
  3. Year for which you would like to start the processing
  	* In the example command, ``2002``
  4. 3-letter abbreciation for the month in which you would like to finish processing
  	* In the example command, ``Jun``
  5. Year for which you would like to end processing
  	* In the example command, ``2015``
  6. Path to directory that you would like to store processed data
  	* In the example command, ``/data7/MODIS/LSTD``

**Outputs**
The output file, **LSTD_avgIRI_Jul2002_Jun2015_mosaicLAEA.tif**, will be stored in the directory you entered as a parameter in the execution command.

### 2. get_mondata_IRI_MODIS1km.sh

This script creates a monthly average for LST Day or LST Night depending on user specifications.

**Example command:**

```
/data4/afsisdata/IRI_MODIS/scripts/./get_data_IRI_MODIS1km.sh LSTD Jul 2002 Jun 2015 /data7/MODIS/LSTD
```

The command above downloads and mosaics for Africa the time series average for LST Day using all available LST Day observations from July 2002 - June 2015.

**Parameters**
  1. Data set that you would like to download. The following are valid entries for this parameter:
  	* LSTD
  	* LSTN
  	* In the example command, ``LSTD`` is used for LST Day
  2. 3-letter abbreviation for the month in which you would like to start the processing
  	* The first available observations for LST were in July 2002
  	* In the example command, ``Jul``
  3. Year for which you would like to start the processing
  	* In the example command, ``2002``
  4. 3-letter abbreciation for the month in which you would like to finish processing
  	* In the example command, ``Jun``
  5. Year for which you would like to end processing
  	* In the example command, ``2015``
  6. Path to directory that you would like to store processed data
  	* In the example command, ``/data7/MODIS/LSTD``

**Outputs**
The output file, **LSTD_avgIRI_Jul2002_Jun2015_mosaicLAEA.tif**, will be stored in the directory you entered as a parameter in the execution command.

### 3. geotiff_scale_clip.sh