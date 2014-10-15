Server: afsisdata
OS: Linux

# DIRECTORY BREAK DOWN

1. `/data1` - Houses the raw data inputs to generate the geoprocessed mosaics for Africa. Also contains the archived final outputs for the MODIS datasets retrieved from the IRI Data Library
2. `/data2` - Houses the final outputs for Africa
3. `/data3` - Houses the GRASS locations and mapsets
4. `/data4` - Staging area for processing

## /DATA1
##### `/data1/afsisdata/MODIS/Albedo_MCD43A3/`
1. Raw Data
  - Albedo_BSA_vis - Black sky visible geotiff observations, 2000-2013
  - Albedo_WSA_vis - White sky visible geotiff observations, 2000-2012.06.25
  - LAI_FPAR_MCD15A2  - Combined Leaf Area Index (LAI) and Fraction of Photosynthetically Active Radiation (FPAR) raw data files in hdf format downloaded from USGS
  - LAI_FPAR_MOD15A2 - Terra Leaf Area Index (LAI) and Fraction of Photosynthetically Active Radiation (FPAR) raw data files in hdf format downloaded from USGS
  - LCDynamics_MCD12Q2 - Combined Land Cover Dynamics raw data files in hdf format downloaded from USGS
  - LCType_MCD12Q1 - Combined Land Cover Type raw data files in hdf format downloaded from USGS
  - npp             

2. Geoprocessed Outputs - contains archived and current outputs
  - EVI                    
  - LstDay          
  - LstNight        
  - NDVI            
  - reflectance_Blue
  - reflectance_MIR
  - reflectance_NIR 
  - reflectance_Red    
  - reproject_tifs_laea_geoserver2012

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


