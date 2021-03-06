### This directory contains the scripts to process the Climate Hazards Group InfraRed Precipitation with Station (CHIRPS) data for Africa. The original data is in geographic projection.

## Scripts
### 1. **get_chirps.sh** <br/>
This script downloads the raw data.

**Example command:** 

``
/data2/CHIRPS/scripts/./get_chirps.sh /data2/CHIRPS 1981 2015
``

**Parameters:**

  1. Path of directory in which to store the raw data
    * ``/data2/CHIRPS``
  2. Start Year - The first CHIRPS observations are available starting in 1981
    * ``1981``
  3. End Year - The CHIRPS is ongoing, so you can put the current year
    * ``2015``

---
### 2. **get_chirps_obs.sh** <br/>
This script creates a text file containing a listing of year with the number of observations for that year.

**Example command:** 

``
/data2/CHIRPS/scripts/get_chirps_obs.sh /data2/CHIRPS/raws 1981 2015
``

**Requirements:**
Before running this script, you need to run **get_chirps.sh** 

**Parameters**
  1. Path of directory in which to store the raw data
    * ``/data2/CHIRPS/raws``
  2. Start Year - The first CHIRPS observations are available starting in 1981
    * ``1981``
  3. End Year - The CHIRPS is ongoing, so you can put the current year
    * ``2015``

---
### 3. **get_chirps_annual.sh** <br/>
This script generates and annual average.

**Example command:** 

``
/data2/CHIRPS/scripts/./get_chirps_annual.sh /data2/CHIRPS/raws 1981 2015 geographic chirps
``

The above command creates an annual average for each year beginning in 1981 through 2015. In other words, there will be an average raster for 1981, an average raster for 1982, ... and an average for 2015.

**Requirements:**
Before running this script, you need to run **get_chirps.sh** 

**Parameters:**

  1. Path of directory that contains the raw CHIRPS observations
    * ``/data2/CHIRPS/raws``
  2. Start Year - The first CHIRPS observations are available starting in 1981
    * ``1981``
  3. End Year - The CHIRPS is ongoing, so you can put the current year
    * ``2015``
  4. GRASS location name - Make sure this GRASS location is created in geographic latitude longitude projection
    * ``geographic``
  5. GRASS mapset name - any name here because the mapset will be created in the script.
    * ``chirps``

---
### 4. **get_chirps_monthly.sh** <br/>
This script generates monthly averages for a given temporal range.

**Example command:** 

``
/data2/CHIRPS/scripts/./get_chirps_monthly.sh /data2/CHIRPS/raws 1981 2015 geographic chirps
``

The command above creates an average of all CHIRPS observations from 1981-2015.

**Requirements:**
Before running this script, you need to run **get_chirps.sh** 

**Parameters:**

  1. Path of directory that contains the raw CHIRPS observations
    * ``/data2/CHIRPS/raws``
  2. Start Year - The first CHIRPS observations are available starting in 1981
    * ``1981``
  3. End Year - The CHIRPS is ongoing, so you can put the current year
    * ``2015``
  4. GRASS location name - Make sure this GRASS location is created in geographic latitude longitude projection
    * ``geographic``
  5. GRASS mapset name - any name here because the mapset will be created in the script.
    * ``chirps``

---
####5. **get_chirps_ts.sh** <br/>
This script creates a time series average for a specified temporal range.

**Example command:** 

``
/data2/CHIRPS/scripts/./get_chirps_ts.sh /data2/CHIRPS/raws 1981 2015 geographic chirps
``

The command above creates a time series average of all the CHIRPS observations from 1981-2015.

**Requirements:**
Before running this script, you need to run **get_chirps.sh** 

**Parameters:**

  1. Path of directory that contains the raw CHIRPS observations
    * ``/data2/CHIRPS/raws ``
  2. Start Year - The first CHIRPS observations are available starting in 1981
    * ``1981``
  3. End Year - The CHIRPS is ongoing, so you can put the current year
    * ``2015``
  4. GRASS location name - Make sure this GRASS location is created in geographic latitude longitude projection
    * ``geographic``
  5. GRASS mapset name - any name here because the mapset will be created in the script.
    * ``chirps``

**Outputs**

A time series average, **CHIRPS_avg_1981_2015.tif**, will be generated in ``/data2/CHIRPS/raws/outputs`` which is created when the script is run.

---
### 6. **get_chirps_sums.sh** <br/>
This script creates an annual sum for all the CHIRPS observations given a specific temporal range.

**Example command:** 

``
/data2/CHIRPS/scripts/./get_chirps_sums.sh /data2/CHIRPS/raws 1981 2015 geographic chirps
``

The command above creates an sum for each year, starting from 1981. There will be an a raster sum for 1981, a raster sum for 1982, ... and a raster sum for 2015.

**Requirements:**
Before running this script, you need to run **get_chirps.sh** 

**Parameters:**

  1. Path of directory that contains the raw CHIRPS observations
    * ``/data2/CHIRPS/raws``
  2. Start Year - The first CHIRPS observations are available starting in 1981
    * ``1981``
  3. End Year - The CHIRPS is ongoing, so you can put the current year
    * ``2015``
  4. GRASS location name - Make sure this GRASS location is created in geographic latitude longitude projection
    * ``geographic``
  5. GRASS mapset name - any name here because the mapset will be created in the script.
    * ``chirps``

---
### 7. **gdal_reproject.sh**<br/>
This script allows you to reproject completed rasters from geographic to Lambert Azimuthal Equal Area.

**Example command:**

``
/data2/CHIRPS/scripts/./gdal_reproject.sh /data2/CHIRPS/raws/output
``

**Parameters:**

  1. Path of directory that contains the layers that you would like to reproject to Lambert Azimuthal Equal Area.
    * ``/data2/CHIRPS/raws/output``

