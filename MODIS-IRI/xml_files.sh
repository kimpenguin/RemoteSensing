#!/bin/bash
#Creates the xml code for the new layers to be used in Jim's code for the Maptool.
#Input: readme_names.txt 
####contains layer names in each line

#/data4/afsisdata/IRI_Sum_test/test_scripts/./xml_files.sh /data4/afsisdata/IRI_Sum_test/test_scripts /data4/afsisdata/IRI_Sum_test/test_scripts


InputDir=$1 
OutputDir=$2

h=1
for newString in $(cat $InputDir/geoserver_layers.txt); do
	arr[$h]=$newString
	h=$((h+1))
done

g=1
for newString2 in $(cat $InputDir/readme_names.txt); do
	arr2[$g]=$newString2
	g=$((g+1))
done


lenArr=${#arr[@]}
echo length of array is $lenArr

i=1
while [ $i -lt $lenArr ]
do
	cur=${arr[$i]}
	curRead=${arr2[$i]}
	name=$(echo ${arr[$i]} | sed 's/.tif//')
	echo $name
	echo "<layer layer_id=\"afsis:test\" tif_file=\"/repository/afsis/services/test/test.tif\" medafile_dir=\"/repository/afsis/docs\">" >> $OutputDir/new_files.txt
	#replaces the name of the file
	sed -i "s/test/"$name"/g" $OutputDir/new_files.txt

	#replaces the name of the readme file
	echo "<metadata file_name=\"test.txt\"/>" >> $OutputDir/new_files.txt
	echo "</layer>" >> $OutputDir/new_files.txt
	echo $curRead
	sed -i "s/test.txt/"$curRead"/g" $OutputDir/new_files.txt


	i=$((i+1))
done
