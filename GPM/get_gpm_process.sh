#!/bin/bash

#/data2/GPM/scripts/get_gpm_process.sh /data2/GPM geographic GPM

InputDir=$1
location=$2
mapset=$3

#########IMPORTING OBSERVATIONS
cd $InputDir

#array of textfiles containing the list of raw data to download - to use in loop
dllist=$(ls 2*.txt)

#loop through each date
for file in $dllist
do
	filedate=${file:0:8}
	echo $filedate
done


# for eachMonth in $months
# do
# 	echo month is $eachMonth
# 	for eachDay in $days
# 	do
# 		echo day is $eachDay
# 		echo "$newWord""$eachMonth""$eachDay"_toDownload.txt
# 		echo ftp://arthurhou.pps.eosdis.nasa.gov/gpmdata/"$newWord"/"$eachMonth"/"$eachDay"/
# 		curl ftp://arthurhou.pps.eosdis.nasa.gov/gpmdata/"$newWord"/"$eachMonth"/"$eachDay"/gis/ --user kmp2143@columbia.edu:kmp2143@columbia.edu > "$newWord""$eachMonth""$eachDay"_toDownload.txt
# 		loop through text file to download the tifs
# 		OutputDir=$InputDir/raws
# 		mkdir $OutputDir
# 		for newFile in $(cat "$newWord"_"$eachMonth"_"$eachDay"_toDownload.txt); do
# 			if [ ${newFile:0:2} == "3B" ]; then
# 				echo ftp://arthurhou.pps.eosdis.nasa.gov/gpmdata/"$newWord"/"$eachMonth"/"$eachDay"/gis/"$newFile"
# 				curl ftp://arthurhou.pps.eosdis.nasa.gov/gpmdata/"$newWord"/"$eachMonth"/"$eachDay"/gis/"$newFile" --user kmp2143@columbia.edu:kmp2143@columbia.edu -o $OutputDir/$newFile
# 			fi
# 		done
# 	done
# done


# echo $tiflist

# rSeriesList=$(echo $tiflist | head -c33)
# echo $rSeriesList

# rSeriesList=$(echo $tiflist | sed "s/ //g")
# echo $rSeriesList

# rSeriesList=$(echo $tiflist | sed "s/\(.*\)-.*/\1/")
# echo $rSeriesList

# word="3B-HHR-GIS.MS.MRG.3IMERG.20141231-S223000-E225959.1350.V03D.tif"
# # test=$(echo $word | sed "s/\(.*\)-.*/\1/")
# # echo $test

# echo $word | sed 's/M*//3g'

# echo $word | sed 's/\(3B-HHR-GIS.S.RG.3IERG.\)/g'

# new=$(echo $tiflist | uniq)
# echo $new

# word="3B-HHR-GIS.MS.MRG.3IMERG.20141231-S233000-E235959.1410.V03D.tif"
# echo ${word:0:33}


# rSeriesList=$(echo $geotiflist | sed "s/ /,/g;s/.tif/@"$mapset"/g")
# #echo $rSeriesList

# for fileNam in $geotiflist
# do
# 	echo $fileNam
# 	newfileNam=$(echo $fileNam | sed "s/.tif//")
# 	r.in.gdal input=$InputDir/$fileNam output=$newfileNam 
# done

# r.out.gdal input=xB_HHR_GIS@gpm output=/data2/GPM/test.tif

# r.null map=xB_HHR_GIS@gpm setnull=0