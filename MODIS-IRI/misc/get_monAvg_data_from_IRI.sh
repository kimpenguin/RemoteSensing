# This script will be used to automate the download of binary r4 files from the IRI Data Library.

#Output: r4 binary files that contain the time series average of the data set specified.

#This script is called by the r4_processing_baseline.sh script if the user prompts
#/data4/afsisdata/IRI_Sum_test/test_scripts/./get_monAvg_data_from_IRI.sh EVI 250 2000 2013 /data1/afsisdata/MODIS/Evi/evi_2000_2013
#/data4/afsisdata/IRI_Sum_test/test_scripts/./get_monAvg_data_from_IRI.sh LST_Day_1km 1000 2002 2013 /data1/afsisdata/MODIS/LstDay/lstday_2000_2013
#/data4/afsisdata/IRI_Sum_test/test_scripts/./get_monAvg_data_from_IRI.sh LST_Night_1km 1000 2002 2013 /data1/afsisdata/MODIS/LstNight/lstnight_2002_2013
#the sequence to enter into the command line:
#call script > dataset name > resolution > start month > start year > end month > end year > output directory

#parameters are assigned to variables
Dataset=$1
Resolution=$2
StartYear=$3
EndYear=$4
OutputDir=$5

#conditional statement reassigns the inputted resolution to its appropriate name in the IRI Data Library.
if [ "$Resolution" == "1000" ]; then
	Resolution=global
else
	Resolution=global250m
fi
          
#static variables to download the calculated average from IRI's Data library
TileNum1=(2 3 4 5 6 7 8 9) #arrays to loop through each of 64 tiles
TileNum2=(2 3 4 5 6 7 8 9)
X=(-1667928 -555977.2 555973.2 1667924 2779874 3891824 5003775 6115725)
Y=(3891828 2779877 1667927 555976.2 -555974.2 -1667925 -2779875 -3891826)

#months="Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"
months="Jan Feb Mar"
for eachMonth in $months  
do
   echo current month is $eachMonth
	time for eachTile1 in ${TileNum1[*]}
	do
		for eachTile2 in ${TileNum2[*]}
		do 
			echo "${TileNum1[eachTile1-2]}" "${TileNum2[eachTile2-2]}"
			echo x="${X[$eachTile1-2]}" y="${Y[$eachTile2-2]}"
	
			if [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "2_2" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "2_6" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "2_7" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "2_8" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "2_9" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "3_6" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "3_7" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "3_8" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "3_9" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "4_7" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "4_8" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "4_9" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "7_2" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "7_9" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "8_2" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "8_3" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "8_9" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "9_2" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "9_3" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "9_6" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "9_7" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "9_8" ] || [ "${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}" == "9_9" ]; then
				echo Not Africa
			else
				echo downloading "$Dataset" "$Resolution" "$Month1" "$Year1" "$Month2" "$Year2" average
				##################################################
				#downloads the binary r4 files of the monthly average done by the IRI Data Library	
				#echo curl "http://iridl.ldeo.columbia.edu/expert/home/.benno/.USGS/.landdaac/.$Resolution/.$Dataset/T/%28"$Month1"%20"$Year1"%29%28"$Month2"%20"$Year2"%29RANGE/X/"${X[$eachTile1-2]}"/VALUE/Y/"${Y[$eachTile2-2]}"/VALUE%5BT%5Daverage/data.r4?filename="$Dataset"_avgIRI_"${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}"_"$Month1""$Year1"_"$Month2""$Year2".r4" -o $OutputDir/"$Dataset"_avgIRI_"$Month1""$Year1"_"$Month2""$Year2"_"${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}".r4
				curl "http://iridl.ldeo.columbia.edu/expert/home/.benno/.USGS/.landdaac/.$Resolution/.$Dataset/T/%28"$StartYear"%29%28"$EndYear"%29RANGE/T/%28"$eachMonth"%29VALUES/X/"${X[$eachTile1-2]}"/VALUE/Y/"${Y[$eachTile2-2]}"/VALUE%5BT%5Daverage/data.r4?filename="$Dataset"_monthlyAvg_"$eachMonth"_"$StartYear"_"$EndYear"_"${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}".r4" -o $OutputDir/"$Dataset"_monthlyAvg_"$eachMonth"_"$StartYear"_"$EndYear"_"${TileNum1[eachTile1-2]}"_"${TileNum2[eachTile2-2]}".r4

			fi
		done
	done
done