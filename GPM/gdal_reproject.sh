#!/bin/bash
#/data2/GPM/scripts/./gdal_reproject.sh /data2/GPM/output

InputDir=$1

#navigate to the Input Directory
cd $InputDir

#######Functions
CurrentProj () {
	echo What is the current projection of all the files in $InputDir ? [enter 1, 2, 3, or 0]
	echo [1] Lambert Azimuthal Equal Area - laea
	echo [2] Geographic Latitude Longitude - latlong
	echo [3] Sinusoidal - sinu
	echo [4] Cylindrical Equal Area
	echo [0] Exit

	read answer
#	echo $answer
	while [[ $answer != 1 && $answer != 2 && $answer != 3 && $answer != 4 && $answer != 0 ]]
	do
		echo ERROR! Please enter valid number.
		CurrentProj
	done

	if [ $answer == 0 ]; then
		echo User chooses to exit
		exit
	fi

	return $answer

}

NextProj () {
	echo To what projection would you like to reproject all the files in $InputDir ? [enter 1, 2, 3, or 0]
	echo [1] Lambert Azimuthal Equal Area - laea
	echo [2] Geographic Latitude Longitude - latlong
	echo [0] Exit

	read answer2
#	echo $answer2
	while [[ $answer2 != 1 && $answer2 != 2 && $answer2 != 0 ]]
	do
		echo ERROR! Please enter valid number.
		NextProj
	done

	if [ $answer2 == 0 ]; then
		echo User chooses to exit
		exit
	fi

	return $answer2

}

#####################


CurrentProj
curr=$?

NextProj
nex=$?

while [ $curr -eq $nex ]
do
	echo CURRENT PROJECTION AND NEXT PROJECTION CANNOT BE THE SAME!
	CurrentProj
	curr=$?
	NextProj
	nex=$?
done	
echo Current Projection is $curr
echo Next Projection is $nex

#creates and Ouput Directory for the reprojected files
OutputDir=$InputDir/reprojected
mkdir $OutputDir

#loops through all files within Input Directory
for file in *.tif
do

	echo $file
	eachFile=${file/\.tif/} #remove the 'tif' from the filename
#	echo $eachFile

	#from Lambert to Geographic
	if [[ $curr == 1 && $nex == 2 ]]; then
		echo User has chosen to reproject from Lambert Azimuthal Equal Area to Geographic Latitude Longitude

		#reproject from Lambert to Geographic Lat Long
		#to prepare the tifs for geoserver, remove the '#' for the two lines below and add '#' before the following two lines under 'reproject from Geographic Lat Long to Lambert'
		time gdalwarp -overwrite -s_srs '+proj=laea +lat_0=5 +lon_0=20 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs' -t_srs '+proj=longlat +datum=WGS84 +no_defs' $InputDir/$eachFile'.tif' $OutputDir/"$eachFile"_latlong'.tif' -multi -wm 5000
		chmod -R 775 $OutputDir/"$eachFile"_latlong.tif
	fi

	#from Geographic to Lambert
	if [[ $curr == 2 && $nex == 1 ]]; then	
		echo User has chosen to reproject from Geographic to Lambert 
		#reproject from Geographic Lat Long to Lambert
		time gdalwarp -overwrite -s_srs '+proj=longlat +datum=WGS84 +no_defs' -t_srs '+proj=laea +lat_0=5 +lon_0=20 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs' $InputDir/$eachFile'.tif' $OutputDir/"$eachFile"_laea'.tif' -multi -wm 5000
		chmod -R 775 $OutputDir/"$eachFile"_laea'.tif'
	fi

	#from Sinusoidal to Lambert
	if [[ $curr == 3 && $nex == 1 ]]; then
		echo User has chosen to reproject from Sinusoidal to Lambert
		#reproject from Sinusoidal to Lambert
		time gdalwarp -overwrite -s_srs '+proj=sinu +lon_0=0 +x_0=0 +y_0=0 +a=6371007.181 +b=6371007.181 +units=m +no_defs' -t_srs '+proj=laea +lat_0=5 +lon_0=20 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs' $InputDir/$eachFile'.tif' "$OutputDir"/"$eachFile"_laea'.tif' -multi -wm 5000
		chmod -R 775 $OutputDir/"$eachFile"_laea'.tif'
	fi
	#from Geographic to Lambert
	if [[ $curr == 4 && $nex == 1 ]]; then	
		echo User has chosen to reproject from Cylindrical Equal Area to Lambert 
		#reproject from Geographic Lat Long to Lambert
		time gdalwarp -overwrite -s_srs '+proj=cea +lon_0=20 +lat_ts=0 +x_0=0 +y_0=0 +no_defs +a=6378137 +rf=298.257223563 +towgs84=0.000,0.000,0.000 +to_meter=1 +datum=wgs84' -t_srs '+proj=laea +lat_0=5 +lon_0=20 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs' $InputDir/$eachFile'.tif' $OutputDir/"$eachFile"_laea'.tif' -multi -wm 5000
		chmod -R 775 $OutputDir/"$eachFile"_laea'.tif'
	fi

done



