#!/bin/bash
#This script is to be used to download the time series MODIS data and calculate the time series average
#/data4/afsisdata/IRI_Sum_test/test_scripts/./time_series_modis.sh /data4/afsisdata/IRI_Sum_test/test_scripts/test /data4/afsisdata/IRI_Sum_test/test_scripts/test_outputs EVI Jan 2003 Sep 2013 sinusoidalSA tsKim


InputDir=$1
OutputDir=$2
DatasetName=$3
StartMon=$4
StartYear=$5
EndMon=$6
EndYear=$7
location=$8
mapset=$9
DatasetRes=250
DatasetRow=4800
DatasetCol=4800
FileType=Float32

#conditional statement reassigns the correct IRI Data Library name for the requested data set.
if [ "$DatasetName" == "evi" ] || [ "$DatasetName" == "EVI" ]; then
	DatasetName=EVI
	DatasetRes=250
	DatasetRow=4800
	DatasetCol=4800
	IriRes=global250m
elif [ "$DatasetName" == "ndvi" ] || [ "$DatasetName" == "NDVI" ]; then
	DatasetName=NDVI
	DatasetRes=250
	DatasetRow=4800
	DatasetCol=4800
	IriRes=global250m
elif [ "$DatasetName" == "blue" ] || [ "$DatasetName" == "reflectance_blue" ]; then
	DatasetName=reflectance_blue
	DatasetRes=250
	DatasetRow=4800
	DatasetCol=4800
	IriRes=global250m
elif [ "$DatasetName" == "red" ] || [ "$DatasetName" == "reflectance_red" ]; then
	DatasetName=reflectance_red
	DatasetRes=250
	DatasetRow=4800
	DatasetCol=4800
	IriRes=global250m
elif [ "$DatasetName" == "mir" ] || [ "$DatasetName" == "MIR" ] || [ "$DatasetName" == "reflectance_MIR" ]; then
	DatasetName=reflectance_MIR
	DatasetRes=250
	DatasetRow=4800
	DatasetCol=4800
	IriRes=global250m
elif [ "$DatasetName" == "nir" ] || [ "$DatasetName" == "NIR" ] || [ "$DatasetName" == "reflectance_NIR" ]; then
	DatasetName=reflectance_NIR
	DatasetRes=250
	DatasetRow=4800
	DatasetCol=4800
	IriRes=global250m
elif [ "$DatasetName" == "lst_day" ] || [ "$DatasetName" == "LST_Day_1km" ]; then
	DatasetName=LST_Day_1km
	DatasetRes=1000
	DatasetRow=1200
	DatasetCol=1200
	IriRes=global
elif [ "$DatasetName" == "lst_night" ] || [ "$DatasetName" == "LST_Night_1km" ]; then
	DatasetName=LST_Night_1km
	DatasetRes=1000
	DatasetRow=1200
	DatasetCol=1200
	IriRes=global
fi       


############Start grass environment

#some settings:
TMPDIR=/tmp

# directory of our software and grassdata:
#MAINDIR=/
# our private /usr/ directory:
#MYUSER=$MAINDIR/Users/username/

# path to GRASS binaries and libraries:
export GISBASE=/usr/lib/grass64

#Create temporary mapset with WIND parameter
mkdir /data3/grassdata/$location/$mapset
cp /data3/grassdata/$location/PERMANENT/WIND /data3/grassdata/$location/$mapset

# generate GRASS settings file:
# the file contains the GRASS variables which define the LOCATION etc.
echo "GISDBASE: /data3/grassdata
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

#initialize g.region for sinusoidal
g.region n=4447803 s=-4447797 e=6671705 w=-2223903 rows=$DatasetRow cols=$DatasetCol

###############A. Determining the maximum number of observations to retrieve from IRI DL
curl http://iridl.ldeo.columbia.edu/expert/home/.benno/.USGS/.landdaac/.$IriRes/.$DatasetName/X/-1667928/VALUE/Y/2779877/VALUE/T/%28"$StartMon"%20"$StartYear"%29%28"$EndMonth"%20"$EndYear"%29RANGE/T/.npts/ -o $InputDir/num_obs.txt

h=1
for newString in $(cat $InputDir/num_obs.txt); do
	arrObs[$h]=$newString
	h=$((h+1))
done
lenArrObs=${#arrObs[@]}

i=1
while [ $i -lt $lenArrObs ]
do
	if [ ${arrObs[$i]} == "<li>" ]; then
		num=${arrObs[$i+1]}	
	fi
	i=$((i+1))
done
max=$(echo $num | sed 's/<.*//')
echo total number of observations in temporal range: $max

###############B. SPECIFYING TILE NAME WITH LONGITUDE AND LATITUDE
TileNum1=(2 3 4 5 6 7 8 9) 
TileNum2=(2 3 4 5 6 7 8 9)
longitude=(-1667928 -555977.2 555973.2 1667924 2779874 3891824 5003775 6115725)
latitude=(3891828 2779877 1667927 555976.2 -555974.2 -1667925 -2779875 -3891826)
longEdges=(-2223903 -1111952 -2 1111948 2223899 3335849 4447800 5559750 6671700)
latEdges=(4447803 3335852 2223902 1111952 1 -1111950 -2223900 -3335850 -4447801)

c=0
while [ $c -lt 8 ]
do
	echo current tile is ${TileNum1[$c]}
	echo current longitude for ${TileNum1[$c]} is ${longitude[$c]}
	
	d=0
	while [ $d -lt 8 ]
	do
		tile=${TileNum1[$c]}"_"${TileNum2[$d]}
		echo $tile
		#specifying center points
		x=${longitude[$c]} 
		y=${latitude[$d]}
		#specifying rangeedges
		x1=${longEdges[$c]}
		x2=${longEdges[$c+1]}
		y1=${latEdges[$d]}
		y2=${latEdges[$d+1]}
		echo Longitude=$x Latitude=$y
		echo x1=$x1 x2=$x2
		echo y1=$y1 y2=$y2
		d=$((d+1))

###############C. DOWNLOADING THE OBSERVATIONS
		#initial value assignments
		m=1
		tValue=1

		while [ $m -lt $max ]
		do
			echo $tile
			#downloads the webpage to extract the date of observation
#			echo curl http://iridl.ldeo.columbia.edu/expert/home/.benno/.USGS/.landdaac/.global250m/.EVI/X/-1667928/VALUE/Y/2779877/VALUE/T/"$tValue"/VALUE/downloadsGeoTiff.html -o $InputDir/date.txt
			curl http://iridl.ldeo.columbia.edu/expert/home/.benno/.USGS/.landdaac/.global250m/.EVI/X/"$x"/VALUE/Y/"$y"/VALUE/T/"$tValue"/VALUE/downloadsGeoTiff.html -o $InputDir/date.txt


			#extracting the date of the observation
			i=1
			for newWord in $(cat $InputDir/date.txt); do
				newWords[$i]=$newWord
				i=$((i+1))
			done
			lenAr=${#newWords[@]}
			echo length of array is $lenAr

			#extracting date of current observation
			j=1	
			while [ $j -lt $lenAr ]
			do

				test=${newWords[$j]}
				if [ "${test:0:10}" == "href=\"%5BX" ]; then
					date=$(echo $test | sed 's/^.*>//')
					break
				fi
				j=$((j+1))
			done
			echo Date is $date
	
			#download the file with correct date 
			curl http://iridl.ldeo.columbia.edu/expert/home/.benno/.USGS/.landdaac/.global250m/.EVI/X/"$x"/VALUE/Y/"$y"/VALUE/T/"$tValue"/VALUE/X/"$x1"/"$x2"/RANGEEDGES/Y/"$y1"/"$y2"/RANGEEDGES/%5BX/Y/%5D/data.tiff?filename=data.tiff -o $OutputDir/"$DatasetName"_"$tile"_$date.tif
			chmod 775 $OutputDir/"$DatasetName"_"$tile"_$date.tif

			################import file into grass
			echo $tile
			#prints out the bounds to the screen
			echo north="$y1" south="$y2" east="$x2" west="$x1" 

			#sets the geographical region for the current tile.
			g.region n=$y1 s=$y2 e=$x2 w=$x1 t=$y1 b=$y2 rows=$DatasetRow cols=$DatasetCol nsres=$DatasetRes ewres=$DatasetRes
	
			#import the geotiff downloaded from IRIDL
			r.in.gdal input=$OutputDir/"$DatasetName"_"$tile"_$date.tif output="$DatasetName"_"$tile"_$date

			#adds name to string of names
			strValue+="$DatasetName"_"$tile"_"$date"@"$mapset"

			#removes the file from the directory
			rm $OutputDir/"$DatasetName"_"$tile"_$date.tif

			#calculation for next observations
			m2=`expr $m + 1`
			m3=`expr $m \\* 15`
			#generates a t-value for the next observation
			tValue=`expr $m2 + $m3`
			echo tvalue for observation $m2 is $tValue

			#goto next observation
			m=$((m+1))

		done
				############Raster calculations
#		echo THE STRING IS $strValue
		strFiles2=$(echo $strValue | sed "s/@"$mapset"/@"$mapset",/g")
		rSeriesFiles=$(echo $strFiles2 | sed "s/.$//")
#		echo $rSeriesFiles

		#average
		r.series input=$rSeriesFiles output="$DatasetName"_avg_"$tile" method=average
		r.out.gdal input="$DatasetName"_avg_"$tile"@"$mapset" output=$OutputDir/"$DatasetName"_avg_"$tile".tif
		chmod 775 $OutputDir/"$DatasetName"_avg_"$tile".tif

		#variance
		r.series input=$rSeriesFiles output="$DatasetName"_var_"$tile" method=variance
		r.out.gdal input="$DatasetName"_var_"$tile"@"$mapset" output=$OutputDir/"$DatasetName"_var_"$tile".tif
		chmod 775 $OutputDir/"$DatasetName"_var_"$tile".tif

	strValue=""
###################END of Section B.
	done

	c=$((c+1))
done
