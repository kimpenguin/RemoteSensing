### This directory contains the scripts to process the Climate Hazards Group InfraRed Precipitation with Station (CHIRPS) data for Africa. The original data is in geographic projection.

## Scripts
### 1. **get_chirps.sh** <br/>
This script downloads the raw data.

**Example command:** 

``
/data2/CHIRPS/scripts/./get_chirps.sh /data2/CHIRPS 1981 2015 geographic chirps
``

**Parameters:**

  1. Path of directory in which to store the raw data
  2. Start Year - The first CHIRPS observations are available starting in 1981
  3. End Year - The CHIRPS is ongoing, so you can put the current year
  4. GRASS location name - Make sure this GRASS location is created in geographic latitude longitude projection
  5. GRASS mapset name - any name here because the mapset will be created in the script.

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
  2. Start Year - The first CHIRPS observations are available starting in 1981
  3. End Year - The CHIRPS is ongoing, so you can put the current year

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
  2. Start Year - The first CHIRPS observations are available starting in 1981
  3. End Year - The CHIRPS is ongoing, so you can put the current year
  4. GRASS location name - Make sure this GRASS location is created in geographic latitude longitude projection
  5. GRASS mapset name - any name here because the mapset will be created in the script.

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
  2. Start Year - The first CHIRPS observations are available starting in 1981
  3. End Year - The CHIRPS is ongoing, so you can put the current year
  4. GRASS location name - Make sure this GRASS location is created in geographic latitude longitude projection
  5. GRASS mapset name - any name here because the mapset will be created in the script.

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
  2. Start Year - The first CHIRPS observations are available starting in 1981
  3. End Year - The CHIRPS is ongoing, so you can put the current year
  4. GRASS location name - Make sure this GRASS location is created in geographic latitude longitude projection
  5. GRASS mapset name - any name here because the mapset will be created in the script.

---
### 6. **get_chirps_sums.sh** <br/>
This script creates an annual sum for all the CHIRPS observations given a specific temporal range.

**Example command:** 

``
/data2/CHIRPS/scripts/./get_chirps_sums.sh /data2/CHIRPS/raws 1981 2015 geographic chirps
``

**Requirements:**
Before running this script, you need to run **get_chirps.sh** 

**Parameters:**

  1. Path of directory that contains the raw CHIRPS observations
  2. Start Year - The first CHIRPS observations are available starting in 1981
  3. End Year - The CHIRPS is ongoing, so you can put the current year
  4. GRASS location name - Make sure this GRASS location is created in geographic latitude longitude projection
  5. GRASS mapset name - any name here because the mapset will be created in the script.

