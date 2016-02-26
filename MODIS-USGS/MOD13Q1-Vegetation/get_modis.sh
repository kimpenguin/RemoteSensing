#!/bin/bash
#Use this script to acquire the MODIS datasets and process without the use of the MODIS Reprojection Tool

#/data2/MODIS/scripts/get_modis.sh /data2/MODIS 2000 2015

InputDir=$1
StartYear=$2
EndYear=$3

cd $InputDir

#create directory to store raw data
RawDir=$InputDir/raws
mkdir $RawDir
#####DOWNLOAD DATA
#gets a list of directories
curl http://e4ftl01.cr.usgs.gov/MOLT/MOD13Q1.005/ --user kmp2143@columbia.edu:kmp2143@columbia.edu > dirDates.txt

#usgs tile list
tileList=(h16v06 h16v07 h16v08 h17v05 h17v06 h17v07 h17v08 h18v05 h18v06 h18v07 h18v08 h18v09 h19v05 h19v06 h19v07 h19v08 h19v09 h19v10 h19v11 h19v12 h20v05 h20v06 h20v07 h20v08 h20v09 h20v10 h20v11 h20v12 h21v06 h21v07 h21v08 h21v09 h21v10 h21v11 h22v07 h22v08 h22v09 h22v10 h22v11 h23v07 h23v08)

year=$StartYear
while [ $((year)) -le $((EndYear)) ]
do
	echo Start Year is $year
	
	for eachDir in $(cat dirDates.txt); do
		if [ ${eachDir:0:4} == "href" ] && [ ${eachDir:6:4} == $year ]; then
			rawDirCurrent=${eachDir:6:10} 
			mkdir $RawDir/$rawDirCurrent
			echo entering directory ${eachDir:6:10} 
			curDir=${eachDir:6:10} 
			curl http://e4ftl01.cr.usgs.gov/MOLT/MOD13Q1.005/$curDir/ > files.txt

			for eachTile in ${tileList[*]}
			do
				# http://e4ftl01.cr.usgs.gov/MOLT/MOD13Q1.005/2000.02.18/MOD13Q1.A2000049.h00v08.005.2006270215540.hdf
				counter=$(grep -c $eachTile files.txt) #counts the number of matches
				grep -m $counter $eachTile files.txt > tileDownloads.txt
				echo $counter
				for eachFile in $(cat tileDownloads.txt); do
					if [ ${eachFile:0:9} == "href=\"MOD" ]; then
						obsFile=$(echo ${eachFile} | sed 's/.*"\(.*\)"[^"]*$/\1/')	
						echo Download $obsFile
						ex=$(echo $obsFile | sed 's/.*\(...\)/\1/')
						if [ ${ex} == "hdf" ]; then
							echo hdf http://e4ftl01.cr.usgs.gov/MOLT/MOD13Q1.005/$curDir/$obsFile
							curl http://e4ftl01.cr.usgs.gov/MOLT/MOD13Q1.005/$curDir/$obsFile -o "$RawDir/$rawDirCurrent"/MOD13Q1_"${eachDir:6:10}"_"$eachTile".hdf
						fi
						if [ ${ex} == "xml" ]; then
							echo xml http://e4ftl01.cr.usgs.gov/MOLT/MOD13Q1.005/$curDir/$obsFile
							curl http://e4ftl01.cr.usgs.gov/MOLT/MOD13Q1.005/$curDir/$obsFile -o "$RawDir/$rawDirCurrent"/MOD13Q1_"${eachDir:6:10}"_"$eachTile".hdf.xml
						fi
					fi
				done
			done
		fi
	done
	year=$((year+1))
done
http://e4ftl01.cr.usgs.gov/MOLT/MOD13Q1.005/2001.09.14/MOD13Q1.A2001257.h02v09.005.2007070014251.hdf
http://e4ftl01.cr.usgs.gov/MOLT/MOD13Q1.005/2001.09.14/MOD13Q1.A2001257.h03v07.005.2007065133212.hdf.xml


#################################### Preparing to export at geotiff

# #create a list of hdf files



# #store gdalinfo into textfile temporarily
# # gdaltxt=$(gdalinfo)

# #search for particular dataset
# new=$(grep -m 1 "SUBDATASET_1_NAME" info.txt)
# echo $new