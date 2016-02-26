### This directory contains the scripts necessary to process the Albedo data products for the Africa Soil Information Service (AfSIS).

###SCRIPTS
get_data_USGS_temporal.sh
get_data_USGS_oneDate.sh

### 1. **get_data_USGS_temporal.sh**

This script downloads the raw data from the USGS.

**Example Command:**

```
/data4/afsisdata/USGS_updates/scripts/get_data_USGS_temporal.sh /data4/afsisdata/albedo 2012 2014 MOTA MCD43A3.005
```

The command above downloads the albedo data from 2012-2014.

**Parameters**
  1. Path of the directory in which you would like to download data.
  	* ``/data4/afsisdata/albedo``
  2. The year in which you would like to start downloading data.
  	* ``2012``
  3. The year in which you would like to stop downloading data.
  	* ``2014`` 
  4. Base directory of the USGS that identifies the satellite that contains the data you would like to download.
  	* ``MOTA``
  5. The NASA product name along with version of the data that you would like to download.
  	* ``MCD43A3.005``

**Outputs**

The results of the script will be stored within a directory, MCD43A3.005, which is created when the script is executed.

---
### 2. **get_data_USGS_oneDate.sh**

This script downloads the raw data for a specific date.

**Example Command:**

```
/data4/afsisdata/USGS_updates/scripts/get_data_USGS_oneDate.sh /data4/afsisdata/albedo MOTA MCD43A3.005 2015.09.30
```

The command above downloads the raw albedo data for September 30, 2015.

**Parameters**
  1. Path of the directory in which you would like to download data.
  	* ``/data4/afsisdata/albedo``
  2. Base directory of the USGS that identifies the satellite that contains the data you would like to download.
  	* ``MOTA``
  3. The NASA product name along with version of the data that you would like to download.
  	* ``MCD43A3.005``
  4. The date that you would like to download in [Year].[Month].[Day] format.
  	* ``2015.09.30``

**Outputs**

The results of the script will be stored within a directory, MCD43A3.005, which is created when the script is executed.