#!/bin/bash
# Performs annual averages of daily TRMM observations

##############################################################################
#Input parameters: 
#/data4/ErosionMapping/TRMM_annual_averages/./trmm_annual_average.sh /data4/ErosionMapping/TRMMdailyAfrica /data4/ErosionMapping/TRMM_annual_averages/AfSIS Geographic trmmKP2 1998
# the year parameter is optional. If the user does not specify a year, the script will perform that annual
# updates for all the years

InputDir=$1
OutputDir=$2
location=$3
mapset=$4
year=$5

#if the user did not enter a year, the script assumes that the user wants annual averages
#for all the available years
if [ -z "$year" ] ; then
	year=0
fi

################################STARTING GRASS ENVIRONMENT
#uses the location and mapset entered by the user

#some settings:
TMPDIR=/tmp

# directory of our software and grassdata:
#MAINDIR=/
# our private /usr/ directory:
#MYUSER=$MAINDIR/Users/sahamed/

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
g.gisenv -n

##################################IMPORTING ALL THE TIFS

##if section relevant if the user did not specify year parameter
if [ $year == 0 ]; then
	year=1998	

	#change to the directory where the inputs are stored
	cd $InputDir
	#creates a list of file names within the Input Directory
	tiflist1=$(ls trmm*.tif)
	#creates an array containing the filenames in each index
	arr=($tiflist1)
	#length of the array
	arrIndices=${#arr[@]}
	echo number of relevant tifs in directory $arrIndices

	#initializes the first index of the array containing the years
	arrYear=($year)	

	i=0
	while [ $i -lt $arrIndices ]
	do
		echo ${arr[$i]}
		#extracts the filename of the current index being called
		nameFile=$(echo ${arr[$i]} | sed 's/.\{4\}$//')
		echo $nameFile
		
		####extracts the year within the filename and adds it to an array of years
		firstfour=$(echo ${nameFile:5:4})
		echo the current year is $firstfour
		if [ $firstfour -gt $year ]; then
			if [[ "${arrYear[@]}" =~ "$firstfour" || "${arrYear[${#arrYear[@]}-1]}" == "${firstfour}" ]]; then
				echo year already in array
			else
				#adds year to the array
				arrYear+=($firstfour)
			fi
		fi

		#Import all tifs into GRASS
		r.in.gdal -o input=$InputDir/${arr[$i]} output=$nameFile

		#increments for the next index
		i=$((i+1))
		echo the new index is $i
	done
	#displays the years within the array
	echo ${arrYear[*]}
	echo length of arrYear is ${#arrYear[@]}

	#######performs the annual average for each year
	m=0
	while [ $m -lt ${#arrYear[@]} ]
	do
		#list of all the relevant files within the Input Directory
		nameList=$(ls trmm_${arrYear[$m]}*.tif)
		#replaces white space with commas and ".tif" with the mapset
		yearList=$(echo $nameList | sed "s/ /,/g;s/.tif/@"$mapset"/g")
		#echo $yearList 
		
		#performs r.series average on all the files within the year
		r.series input=$yearList output=trmmD_avg_${arrYear[$m]} method=average
		# later define type=$FileType 
		r.out.gdal input=trmmD_avg_"${arrYear[$m]}"@"$mapset" output=$OutputDir/trmmD_avg_"${arrYear[$m]}".tif
		chmod 775 $OutputDir/trmmD_avg_"${arrYear[$m]}".tif

		m=$((m+1))		
	done


###else statement relevant if user enters year parameter
else
	#changes location to the Input Directory
	cd $InputDir

	#initializes a list of relevant files in the Input Directory
	tiflist2=$(ls trmm_$year*.tif)
#	echo $tiflist2
	yearList2=$(echo $tiflist2 | sed "s/ /,/g;s/.tif/@"$mapset"/g")
#	echo $yearList2

	#initializes array containing the relevant filenames
	arr2=($tiflist2)
	arr2Indices=${#arr2[@]}
	echo number of relevant tifs in directory $arr2Indices

	j=0
	while [ $j -lt $arr2Indices ]
	do
		echo ${arr2[$j]}
		nameFile=$(echo ${arr2[$j]} | sed 's/.\{4\}$//')

		#Import all tifs into GRASS
		r.in.gdal -o input=$InputDir/${arr2[$j]} output=$nameFile

		#increments for the next index
		j=$((j+1))
		echo the new index is $j
	done

	#performs r.series average on all the files within the year
	r.series input=$yearList2 output=trmmD_avg_$year method=average
	# later define type=$FileType 
	r.out.gdal input=trmmD_avg_"$year"@"$mapset" output=$OutputDir/trmmD_avg_"$year".tif
	chmod 775 $OutputDir/trmmD_avg_"$year".tif

fi

