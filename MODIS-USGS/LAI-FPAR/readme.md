### This directory contains the scripts necessary to process the MODIS MOD15A2 and MCD15A2 Leaf Area Index and Fraction of Photosynthetically Active Radiation 1000m resolution for the Africa Soil Information Service (AfSIS).

###SCRIPTS
get_data_USGS_temporal.sh
get_data_USGS_oneDate.sh


### 1. **get_data_USGS_temporal.sh**

This script downloads the raw data from the USGS.

**Example Command:**

```
/data4/afsisdata/USGS_updates/scripts/get_data_USGS_temporal.sh /data4/afsisdata/USGS_updates/fparlai 2012 2014 MOLT MOD15A2.005
```

The command above downloads the LAI/FPAR data from 2012-2014.

**Parameters**

  1. Path of the directory in which you would like to download data.
  	* ``/data4/afsisdata/USGS_updates/fparlai``
  2. The year in which you would like to start downloading data.
  	* ``2012``
  3. The year in which you would like to stop downloading data.
  	* ``2014`` 
  4. Base directory of the USGS that identifies the satellite that contains the data you would like to download. You can choose the following:
    * MOLT
    * MOTA
  	* In the example command, ``MOLT``
  5. The NASA product name along with version of the data that you would like to download. You can choose the following:
    * MCD15A2.005
    * MOD15A2.005
  	* In the example command, ``MOD15A2.005``

**Outputs**

The results of the script will be stored within a directory, MCD43A3.005, which is created when the script is executed.

---
### 2. **get_data_USGS_oneDate.sh**

This script downloads the raw data for a specific date.

**Example Command:**

```
/data4/afsisdata/USGS_updates/scripts/get_data_USGS_oneDate.sh /data4/afsisdata/USGS_updates/fparlai MOTA MCD43A3.005 2002.07.04
```

The command above downloads the raw albedo data for July 04, 2002.

**Parameters**

  1. Path of the directory in which you would like to download data.
  	* ``/data4/afsisdata/USGS_updates/fparlai``
  2. Base directory of the USGS that identifies the satellite that contains the data you would like to download. You can choose the following:
    * MOLT
    * MOTA
    * In the example command, ``MOLT``
  3. The NASA product name along with version of the data that you would like to download. You can choose the following:
    * MCD15A2.005
    * MOD15A2.005
    * In the example command, ``MOD15A2.005``
  4. The date that you would like to download in [Year].[Month].[Day] format.
  	* ``2002.07.04``

**Outputs**

The results of the script will be stored within a directory, MCD43A3.005, which is created when the script is executed.

---
### 3. **laifpar_mosaic.sh**

This script mosaics the leaf area index and fpar observations for Africa.

**Example Command:**
```
/data4/afsisdata/USGS_updates/scripts/./laifpar_mosaic.sh /data4/afsisdata/USGS_updates/laifpar/MOD15A2.005
```

**Parameters**
  1. Path of the directory into which you would like to store the mosaics
    * ``/data4/afsisdata/USGS_updates/laifpar/MOD15A2.005``

**Outputs**

The mosaics will stored in a directory, **africa**, which his created in the path entered when the script was executed.

---
### 4. **laifpar_ts.sh**

This script creates a time series average, standard deviation, and variance for the leaf area index or fpar.

**Example Command:**

```
/data4/afsisdata/USGS_updates/scripts/./laifpar_ts.sh /data1/afsisdata/MODIS/LAI_FPAR_MCD15A2/Fpar MCD15A2 Fpar Geographic fparMCD2015
```

**Parameters**

  1. Path of the directory that contains the mosaicked images
    * ``/data1/afsisdata/MODIS/LAI_FPAR_MCD15A2/Fpar``
  2. NASA product name that contains the data set you want to process. You have two choices:
    * MCD15A2
    * MOD15A2
    * In the example command, ``MCD12A2``
  3. The data set that you would like to process. You have two choices:
    * Fpar
    * Lai
    * In the example command, ``Fpar``
  4. Name of the GRASS location in geographic projection
    * In the example command, ``Geographic``
  5. Name of mapset you would like created in the GRASS location. You can type anything here.
    * In the example command, ``fparMCD2015``


**Outputs**

The time series average, standard deviation, and variance are stored in the directory, **outputs**, in the path given as a parameter when the script was executed.

---
### 5. **laifpar_monthly.sh**

This script creates a time series monthly average of the lai or fpar.

**Example Command:**

```
/data4/afsisdata/USGS_updates/scripts/./laifpar_monthly.sh /data1/afsisdata/MODIS/LAI_FPAR_MCD15A2/Fpar MCD15A2 Fpar Geographic mcd15a2Fpar
```

**Parameters**

  1. Path of the directory that contains the mosaicked geotiffs
    * ``/data1/afsisdata/MODIS/LAI_FPAR_MCD15A2/Fpar``
  2. NASA product name that contains the data set you want to process. You have two choices:
    * MCD15A2
    * MOD15A2
    * In the example command, ``MCD12A2``
  3. The data set that you would like to process. You have two choices:
    * Fpar
    * Lai
    * In the example command, ``Fpar``
  4. Name of the GRASS location in geographic projection
    * In the example command, ``Geographic``
  5. Name of mapset you would like created in the GRASS location. You can type anything here.
    * In the example command, ``mcd15a2Fpar``

**Outputs**

The monthlies are stored in the directory, **outputs**, that was created in the directory entered as a parameter when the script was executed.

---
### 6. **laifpar_annual.sh**

This script create an annual average of the lai or fpar.

**Example Command:**

```
/data4/afsisdata/USGS_updates/scripts/./laifpar_annual.sh /data1/afsisdata/MODIS/LAI_FPAR_MCD15A2/Fpar MCD15A2 Fpar Geographic mcd15a2Fpar
```

**Parameters**

  1. Path of the directory that contains the mosaicked geotiffs
    * ``/data1/afsisdata/MODIS/LAI_FPAR_MCD15A2/Fpar``
  2. NASA product name that contains the data set you want to process. You have two choices:
    * MCD15A2
    * MOD15A2
    * In the example command, ``MCD12A2``
  3. The data set that you would like to process. You have two choices:
    * Fpar
    * Lai
    * In the example command, ``Fpar``
  4. Name of the GRASS location in geographic projection
    * In the example command, ``Geographic``
  5. Name of mapset you would like created in the GRASS location. You can type anything here.
    * In the example command, ``mcd15a2Fpar``

**Outputs**

The annuals are stored within the directory, **outputs**, that was created in the directory entered as a parameter when the script was executed.