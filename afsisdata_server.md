Server: afsisdata
OS: Linux

# DIRECTORY BREAK DOWN

1. `/data1` - Houses the raw data inputs to generate the geoprocessed mosaics for Africa. Also contains the archived final outputs for the MODIS datasets retrieved from the IRI Data Library
2. `/data2` - Houses the final outputs for Africa
3. `/data3` - Houses the GRASS locations and mapsets
4. `/data4` - Staging area for processing

## /DATA1
##### `/data1/afsisdata/MODIS/...`
1. Raw Data
  1. `Albedo_MCD43A3/...` - MODIS Combined Albedo
    - `Albedo_BSA_vis` - Black sky visible geotiff observations, 2000-2013
    - `Albedo_WSA_vis` - White sky visible geotiff observations, 2000-2012.06.25
  2. `LAI_FPAR_MCD15A2`  - MODIS Combined Leaf Area Index (LAI) and Fraction of Photosynthetically Active Radiation (FPAR)
  3. `LAI_FPAR_MOD15A2` - MODIS Terra Leaf Area Index (LAI) and Fraction of Photosynthetically Active Radiation (FPAR)
  4. `LCDynamics_MCD12Q2` - MODIS Combined Land Cover Dynamics raw data files in hdf format downloaded from USGS
  5. `LCType_MCD12Q1` - MODIS Combined Land Cover Type
  6. `npp`             

2. Geoprocessed Outputs - contains archived and current outputs
  1. `EVI/`
    - Latest: `EVI_200002_201403'   
      - EVI_avgIRI_Jan2000_Mar2014_mosaicLAEA.tif - lambert azimuthal equal area projection, not clipped
      - EVI_avgIRI_Jan2000_Mar2014_mosaicLAEA_x10000.tif - lambert azimuthal equal area projection, clipped and mulitplied by 10000
      - EVI_avgIRI_Jan2000_Mar2014_mosaic.tif - sinusoidal projection, not clipped            
  2. `LstDay/`
    - Latest:          
  3. `LstNight/`
    - Latest:        
  4. `NDVI/`  
    - Latest:     
  5. `reflectance_Blue/`
    - Latest:
  6. `reflectance_MIR/`
    - Latest:
  7. `reflectance_NIR/`
    - Latest:
  8. `reflectance_Red/` 
    - Latest: 

## /DATA3
**`/data4/ErosionMapping/TRMM/TRMMdailyAfrica/…`**
1. `/annual_averages`
  - `/geographic_latlong/clipped_latlong` - Annual averages clipped for Africa in Geographic Lat Long projection.
  - `/reprojected_laea/clipped_laea` - Annual averages clipped for Africa in Lambert Azimuthal Equal Area projection.
- Temporal Coverage: 1998-2013
- Status: Complete until Jan 2015

2. `/annual_variance`
  - `/geographic_latlong/clipped_latlong` - Annual variances clipped for Africa in Geographic Lat Long projection.
  - `/reprojected_laea/clipped_laea` - Annual variances clipped for Africa in Lambert Azimuthal Equal Area projection.
- Temporal Coverage: 1998-2013
- Status: Complete until Jan 2015

3. `/average_rainy_days`
  - `/geographic_latlong/clipped_latlong` - Annual and time series average number of rainy days clipped for Africa in Geographic Lat Long projection.
  - `/reprojected_laea/clipped_laea` - Annual and time series average number of rainy days clipped for Africa in Lambert Azimuthal Equal Area projection.
- Temporal Coverage: 1998-2012
- Status: updating

4. `/modified_fournier_index`
  - `/geographic_latlong/clipped_latlong` - Annual and time series modified Fournier index clipped for Africa in Geographic Lat Long projection.
  - `/reprojected_laea/clipped_laea` - Annual and time series modified Fournier index clipped for Africa in Lambert Azimuthal Equal Area projection.
- Temporal Coverage: 1998-2013
- Status: Complete until Jan 2015

5. `/time_series/average`
  - `/geographic_latlong/clipped_latlong` - Time series average clipped for Africa in Geographic Lat Long projection.
  - `/reprojected_laea/clipped_laea` - Time series average clipped for Africa in Lambert Azimuthal Equal Area projection.
- Temporal Coverage: 1998-2012
- Status: updating

**`/data4/ErosionMapping/WorldClim/…`**
1. `/bio1` - Worldclim Temperature
  - `/outputs/geographic_latlong` - Time series average for Africa in Geographic Lat Long projection.
  - `/outputs/reprojected_laea` - Time series average for Africa in Lambert Azimuthal Equal Area projection.
- Temporal Coverage: 1950-2000
- Status: Complete

2. `/bio12` - WorldClim Precipitation
  - `/outputs/geographic_latlong` - Time series average and modified Fournier index for Africa in Geographic Lat Long projection.
  - `/outputs/reprojected_laea` - Time series average and modified Fournier index for Africa in Lambert Azimuthal Equal Area projection.
- Temporal Coverage: 1950-2000
- Status: Complete


