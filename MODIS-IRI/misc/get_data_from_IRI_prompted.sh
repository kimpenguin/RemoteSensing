#!/bin/bash
# This script will be used to automate the download of binary r4 files from the IRI Data Library.

#Output: r4 binary files that contain the time series average of the data set specified.

#This script is called by the r4_processing_baseline.sh script if the user prompts
#/data4/afsisdata/IRI_MODIS/scripts/./get_data_from_IRI_prompted.sh

#the sequence to enter into the command line:
#call script > dataset name > resolution > start month > start year > end month > end year > output directory

Starter () {
	echo Please select from the following
	echo [1] Time Series
	echo [2] Annual
	echo [0] EXIT

	#stores users values in answer
	read answer

	#makes sure that the user enters valid values
	while [[ $answer -gt 2 ]]
	do
		echo ERROR!
		Starter
	done

	if [ $answer -eq 0 ]; then
		exit
	fi
	return $answer
}

TimeSeries () {
	echo You have chosen to get Time Series Data
	echo What would you like to download?
	echo [1] Monthly Time Series Averages
	echo [2] Full Time Series Average
	echo [0] EXIT

	#stores users values in answer
	read answer1

	#makes sure that the user enters valid values
	while [[ $answer2 -gt 2 ]]
	do
		echo ERROR!
		TimeSeries 
	done

	if [ $answer1 -eq 0 ]; then
		exit
	fi

	return $answer1
}

Annual () {
	echo You have chosen to get Annual Data
	echo What would you like to download?
	echo [1] Monthly Averages
	echo [2] Annual Average
	echo [0] EXIT
	#stores users values in answer
	read answer2

	#makes sure that the user enters valid values
	while [[ $answer2 -gt 2 ]]
	do
		echo ERROR!
		Annual
	done
	
	if [ $answer1 -eq 0 ]; then
		exit
	fi

	return $answer2
}

##################################
#Starts the program:
Starter
ret=$?
echo HEY HERE IT IS $ret

if [ $ret -eq 1 ] ; then
	TimeSeries
	ret1=$?
	echo returned $ret1
elif [ $ret -eq 2 ] ; then
	Annual
	ret2=$?
	echo also returned $ret2
fi
