### This directory contains the BASH scripts used to develope the Global Precipitation Measurement (GPM) remote sensing covariates for the Africa Soil Information Service (AfSIS).

##Scripts
### 1. **get_gpm.sh**

This script downloads the raw data and then creates a time series average.

**Example command:**

``/data2/GPM/scripts/./get_gpm.sh /data2/GPM 2014 2015``

**Parameters**

  1. Path of directory where all the GPM directories and files are stored
    * ``/data2/GPM``
  2. Start Year - The first GPM observations are available starting in 2014
    * ``2014``
  3. End Year - The GPM is ongoing, so you can put the current year
    * ``2015``

**Output**

The raw data will be stored in a directory, **raws**, that is created when the script is run.

---
### 2. **get_gpm_ts.sh**

This script creates an average based on a specified temporal range. Before you run this script, make sure you have run **get_gpm.sh**.

**Example command:**
``/data2/GPM/scripts/./get_gpm_ts.sh /data2/GPM 2014 2015 geographic GPM``


**Parameters**

  1. Path of directory where all the GPM directories and files are stored
    * ``/data2/GPM``
    * NOTE!!! Use the same directory you used to run the **get_gpm.sh**
  2. Start Year - The first GPM observations are available starting in 2014
    * ``2014``
  3. End Year - The GPM is ongoing, so you can put the current year
    * ``2015``
  4. GRASS location name - Make sure this GRASS location is created in geographic latitude longitude projection
    * ``geographic``
  5. GRASS mapset name - any name here because the mapset will be created in the script.
    * ``gpm``

 **Output**

 The output time series will be stored in a directory, **output**, that is created when the script is run.

 ---
### 3. **gdal_reproject.sh**<br/>
This script allows you to reproject completed rasters from geographic to Lambert Azimuthal Equal Area.

**Example command:**

``
/data2/CHIRPS/scripts/./gdal_reproject.sh /data2/GPM/output
``

**Parameters:**

  1. Path of directory that contains the layers that you would like to reproject to Lambert Azimuthal Equal Area.
    * ``/data2/GPM/output``
