### This directory contains the scripts necessary to process the Albedo data products for the Africa Soil Information Service (AfSIS).

###SCRIPTS
get_data_USGS_temporal.sh
get_data_USGS_oneDate.sh
albedo_mosaic_regions_USGS.sh
albedo_mosaic_Africa_USGS.sh
albedo_geoprocessing.sh

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

---
### 3. albedo_mosaic_regions_USGS.sh

This script creates a mosaic for the east, west and south of Africa.

**Example Command:**
```
/data4/afsisdata/USGS_updates/scripts/./albedo_mosaic_regions_USGS.sh /data4/afsisdata/albedo/MCD43A3.005 Albedo_BSA_Band_vis
```

The command above creates three mosaics for the albedo black sky visible band for each region of Africa (east, west, south).

**Parameters**

  1. Path of directory that contains the raw data.
  	* ``/data4/afsisdata/USGS_updates/albedo/MCD43A3.005``
  2. Albedo band that you would like to process.
  	* ``Albedo_BSA_Band_vis``

**Outputs**

The region mosaics are stored in the directory, **regions**, which is created when the script is executed.
---
### 4. albedo_mosaic_Africa_USGS.sh

This script mosaics the three regions into a continent-wide Africa raster.

**Example Command:**

```
/data4/afsisdata/USGS_updates/scripts/./albedo_mosaic_Africa_USGS.sh /data4/afsisdata/USGS_updates/albedo/regions Albedo_BSA_vis
```

The command above creates a mosaic of Africa using the three region rasters that were created for the albedo black sky visible band.

**Parameters**

  1. Path of directory that contains the three regions
  	* ``/data4/afsisdata/USGS_updates/albedo/regions``
  2. Albedo band that you would like to process.
  	* ``Albedo_BSA_Band_vis``

**Outputs**

The Africa mosaic is stored in the directory, **africa**, which is created when the script is executed.

---
### 5. albedo_geoprocessing.sh

This script calculates the time series average, standard deviation, and variance.

**Example Command:**

```
/data4/afsisdata/USGS_updates/scripts/./albedo_geoprocessing.sh /data2/afsisdata/MODIS/Albedo_BSA_vis/africa BSA_vis sinusoidalSA kpeng
```

**Parameters**

  1. Path of the directory that contains the Africa mosaics
  	* ``/data2/afsisdata/MODIS/Albedo_BSA_vis/africa``
  2. Albedo band that you would like to process
  	* ``BSA_vis``
  3. Name of the sinusoidal GRASS location in which you would like to process
  	* ``sinusoidal``
  4. Name of mapset that will be created in the sinusoidal location
  	* ``kpeng``

**Outputs**

The time series average, standard deviation, and variance are stored in the directory, outputs, created when the script is executed.