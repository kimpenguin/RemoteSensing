#!/bin/bash
##Reproject tifs to projection of the current location and mapset from the old location and mapset

#/data4/afsisdata/IRI_Sum_test/test_scripts/./grass_reproject.sh /data4/afsisdata/IRI_Sum_test/fpar_MCD_update_sep2013 /data4/afsisdata/IRI_Sum_test/fpar_MCD_update_sep2013 LambertFinalNov2013 PERMANENT GeographicFinalNov2013 PERMANENT laea 1000


#explaining parts of above command
#call script > input directory > output directory > new location > new mapset > old location > old mapset > new projection



##############################################################################
#Start grass environment

#some settings:
TMPDIR=/tmp

# directory of our software and grassdata:
#MAINDIR=/
# our private /usr/ directory:
#MYUSER=$MAINDIR/Users/username/

# path to GRASS binaries and libraries:
export GISBASE=/usr/lib/grass64

#Create temporary mapset with WIND parameter
#mkdir /data4/grassdata/$location/$mapset
#cp /data4/grassdata/$location/PERMANENT/WIND /data4/grassdata/$location/$mapset

# generate GRASS settings file:
# the file contains the GRASS variables which define the LOCATION etc.
echo "GISDBASE: /data4/grassdata
LOCATION_NAME: $location
MAPSET: $mapset
" > $TMPDIR/.grassrc6_modis$$

# path to GRASS settings file:
export GISRC=$TMPDIR/.grassrc6_modis$$

# first our GRASS, then the rest
export PATH=$GISBASE/bin:$GISBASE/scripts:$PATH
#first have our private libraries:
export LD_LIBRARY_PATH=$GISBASE/lib:$LD_LIBRARY_PATH

# use process ID (PID) as lock file number:
export GIS_LOCK=$$

# this should print the GRASS version used:
g.version 
#g.gisenv -n

#######################reprojecting
cd $InputDir

for file in *.tif
do
	echo $file
	eachFile=${file/\.tif/} #remove the 'tif' from the filename
	echo $eachFile
	r.proj input=$eachFile location=$oldlocation mapset=$oldmapset output="$eachFile"_$newprojection method=bilinear resolution=$resolution
done

