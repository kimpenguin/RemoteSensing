#!/bin/bash
#This script will allow the user to select the MODIS data set, temporal range, and calculation.

#/data4/afsisdata/IRI_Sum_test/test_scripts/./modis_prompts.sh

echo Hello and welcome to the MODIS Data Set Collection.


x=$(date)
presentYear=$(echo ${x:24:29})
#echo $presentYear
presentMon=$(echo ${x:4:5})	
#echo $presentMon

months=("Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec")


#LEGEND FUNCTION
ModisLegend () {
	echo
	echo Please select a number or 0 to exit.
	echo Legend:
	echo [1] - Land Surface Temperature, Day
	echo [2] - Land Surface Temperature, Night
	echo [3] - Enhanced Vegetation Index
	echo [4] - Normalized Difference Vegetation Index
	echo [5] - Red Reflectance, Band 1
	echo [6] - Near Infrared Reflectance, Band 2
	echo [7] - Blue Reflectance, Band 3
	echo [8] - Mid Infrared Reflectance, Band 7
	echo [0] - Exit
	echo What would you like to do?
	#stores users values in answer
	read answer
	
	#makes sure that the user enters valid values
	while [[ $answer -gt 7 ]]
	do
		echo ERROR!
		ModisLegend
	done
	return $answer

}

Month () {
	usrMon=$1
	

	for i in ${months[@]}
	do
		if [ "$i" == "$usrMon" ] ; then
			return 1
		fi
	done
}

Year () {
	usrYear=$1
	usrDataset=$2

	if [ "$usrDataset" == "LST" ]; then
		if [ $usrYear -lt 2002 ]; then
			return 0
		elif [ $usrYear -gt $presentYear ]; then
			return 0
		else
			return 1
		fi
	fi

	if [ $usrDataset != "LST" ]; then
		if [ $usrYear -lt 2002 ]; then
			return 0
		elif [ $usrYear -gt $presentYear ]; then
			return 0
		else
			return 1
		fi

	fi

}

ModisDownloadType () {
	echo MODIS DOWNLOAD TYPE
	value=$1
	#obtaining the current path where all the scripts should be stored
	directorypath=$(pwd)

	if [ $value == 1 ]; then
		echo User selected [1] LAND SURFACE TEMPERATURE
		#creating a directory to store data
		echo mkdir $directorypath/AfSIS_LST_Day_Data
		echo chmod -R 775 $directorypath/AfSIS_LST_Day_Data

		
		#determining the user's desired temporal range
		echo For what temporal range would you like to retrieve data? [Available: Jul 2002 - $presentMon $presentYear]
		echo Please enter starting month [Valid: Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec]
		read monVal
		startMon=${monVal:0:3}	
		echo $startMon
		#check whether the user entered a valid month
		Month $startMon
		mtest=$?
		while [ $mtest -ne 1 ]
		do
			echo please reenter start month
			read startMon
			Month $startMon
			mtest=$?
		done

	
		echo Please enter starting year [Valid: 2002, 2003, 2004, 2005, etc.]
		read startYear
		Year $startYear "LST"
		ytest=$?
		while [ $ytest -ne 1 ]
		do
			echo Please reenter start year
			read startYear
			Year $startYear "LST"
			ytest=$?
		done


		echo Please enter end month [Valid: Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec]
		read monVal2 
		endMon=${monVal2:0:3}
		#check whether the user entered a valid month
		Month $endMon
		mtest2=$?
		while [ $mtest2 -ne 1 ]
		do
			echo please reenter end month
			read endMon
			Month $endMon
			mtest2=$?
		done

		echo Please enter end year [Valid: 2002, 2003, 2004, 2005, etc.]
		read endYear
		Year $endYear "LST"
		ytest=$?
		while [ $ytest -ne 1 ]
		do
			echo Please reenter end year
			read endYear
			Year $endYear "LST"
			ytest=$?
		done

		
		echo You have selected the temporal range: $startMon $startYear - $endMon $endYear
		echo Is this correct?



#######################
	elif [ $value == 3 ]; then
		echo User selected [3] ENHANCED VEGETATION INDEX
		#creating a directory to store data
		echo mkdir $directorypath/AfSIS_LST_Night_Data
		echo chmod -R 775 $directorypath/AfSIS_LST_Night_Data


		#determining the user's desired temporal range
		echo For what temporal range would you like to retrieve data? [Available: Feb 2000 - $presentMon $presentYear]

	elif [ $value == 4 ]; then
		echo User selected [4] NORMALIZED DIFFERENCE VEGETATION INDEX
		#creating a directory to store data
		echo mkdir $directorypath/AfSIS_NDVI_Data
		echo chmod -R 775 $directorypath/AfSIS_NDVI_Data
	elif [ $value == 5 ]; then
		echo User selected [5] RED REFLECTANCE, BAND 1
		#creating a directory to store data
		echo mkdir $directorypath/AfSIS_Red_Data
		echo chmod -R 775 $directorypath/AfSIS_Red_Data
	elif [ $value == 6 ]; then
		echo User selected [6] NEAR INFRARED REFLECTANCE, BAND 2
		#creating a directory to store data
		echo mkdir $directorypath/AfSIS_NIR_Data
		echo chmod -R 775 $directorypath/AfSIS_NIR_Data
	elif [ $value == 7 ]; then
		echo User selected [7] BLUE REFLECTANCE, BAND 3
		#creating a directory to store data
		echo mkdir $directorypath/AfSIS_Blue_Data
		echo chmod -R 775 $directorypath/AfSIS_Blue_Data	
	elif [ $value == 8 ]; then
		echo User selected [8] MID INFRARED REFLECTANCE, BAND 7
		#creating a directory to store LST data
		echo mkdir $directorypath/AfSIS_MIR_Data
		echo chmod -R 775 $directorypath/AfSIS_MIR_Data
	fi
}

#############################
#Displays the legend and asks the user to enter a response
ModisLegend
echo User response: $answer

if [ $answer != 0 ]; then
	#creating directory to store TRMM data
	echo directory AfSIS_MODIS_Data is created
	echo mkdir AfSIS_MODIS_Data
	echo chmod -R 775 AfSIS_MODIS_Data
else
	exit
fi

#script continues to run until the user chooses to exit
while [ $answer != 0 ]
do
	ModisDownloadType $answer
	ModisLegend
done
