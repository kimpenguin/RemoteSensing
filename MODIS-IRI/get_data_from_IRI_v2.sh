#!/bin/bash
# This script will be used to automate the download of binary r4 files from the IRI Data Library.

#Output: r4 binary files that contain the time series average of the data set specified.

#This script is called by the r4_processing_baseline.sh script if the user prompts
#/data4/afsisdata/IRI_Sum_test/test_scripts/./get_data_from_IRI_v2.sh NDVI 250m Feb 2000 Mar 2014 16day /data4/afsisdata/IRI_Sum_test/ndvi200002_201403

#the sequence to enter into the command line:
#call script > dataset name > resolution > start month > start year > end month > end year > output directory

#parameters are assigned to variables
Dataset=$1
Resolution=$2
Month1=$3
Year1=$4
Month2=$5
Year2=$6
Temporal=$7
OutputDir=$8

#conditional statement reassigns the inputted resolution to its appropriate name in the IRI Data Library.
#if [ "$Resolution" == "1000" ]; then
#	Resolution=global
#else
#	Resolution=global250m
#fi
          
#static variables to download the calculated average from IRI's Data library
TileNum1=(2 3 4 5 6 7 8 9) #arrays to loop through each of 64 tiles
TileNum2=(2 3 4 5 6 7 8 9)
X=(-1667928 -555977.2 555973.2 1667924 2779874 3891824 5003775 6115725)
Y=(3891828 2779877 1667927 555976.2 -555974.2 -1667925 -2779875 -3891826)
time for eachTile1 in ${TileNum1[*]}
do
    for eachTile2 in ${TileNum2[*]}
    do 
	echo "${TileNum1[eachTile1-2]}" "${TileNum2[eachTile2-2]}"
	echo x="${X[$eachTile1-2]}" y="${Y[$eachTile2-2]}"
	
	if [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "2_2" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "2_6" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "2_7" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "2_8" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "2_9" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "3_6" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "3_7" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "3_8" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "3_9" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "4_7" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "4_8" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "4_9" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "7_2" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "7_9" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "8_2" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "8_3" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "8_9" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "9_2" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "9_3" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "9_6" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "9_7" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "9_8" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "9_9" ]; then
		echo Not Africa
	else
		echo downloading "$Dataset" "$Temporal" "$Resolution" "$Month1" "$Year1" "$Month2" "$Year2" average
		##################################################
		#downloads the binary r4 files of the calculated average done by the IRI's Data Library	
		echo http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.$Resolution/.$Temporal/.$Dataset/T/%28"$Month1"%20"$Year1"%29%28"$Month2"%20"$Year2"%29RANGE/X/"${X[$eachTile1-2]}"/VALUE/Y/"${Y[$eachTile2-2]}"/VALUE%5BT%5Daverage/data.r4
		curl "http://iridl.ldeo.columbia.edu/expert/SOURCES/.USGS/.LandDAAC/.MODIS/.$Resolution/.$Temporal/.$Dataset/T/%28"$Month1"%20"$Year1"%29%28"$Month2"%20"$Year2"%29RANGE/X/"${X[$eachTile1-2]}"/VALUE/Y/"${Y[$eachTile2-2]}"/VALUE%5BT%5Daverage/data.r4?filename="$Dataset"_avgIRI_"${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}"_"$Month1""$Year1"_"$Month2""$Year2".r4" -o $OutputDir/"$Dataset"_avgIRI_"$Month1""$Year1"_"$Month2""$Year2"_"${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}".r4
	fi
    done
done

