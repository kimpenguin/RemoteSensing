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
This script creates a text file containing the number of observations for each year
**Example command:** <br/>
``
/data2/CHIRPS/scripts/get_chirps_obs.sh /data2/CHIRPS/raws 1981 2015
``<br/>
**Requirements:**
Before running this script, you need to run **get_chirps.sh** <br/>

**Parameters**
  1. Path of directory in which to store the raw data
  2. Start Year - The first CHIRPS observations are available starting in 1981
  3. End Year - The CHIRPS is ongoing, so you can put the current year
---
### 3. **get_chirps_annual.sh** <br/>
This script can be used to get the average for each year or for the complete time series

### 4. **get_chirps_monthly.sh** <br/>
This script can be used to get the monthly average, annual or for the complete time series

####5. **get_chirps_ts.sh** <br/>
This script creates a time series of specific temporal range.

### 6. **get_chirps_sums.sh** <br/>
This script creates a sum for each year.

