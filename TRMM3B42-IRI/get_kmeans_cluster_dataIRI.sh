#!/bin/bash
# script downloads all relevant files for kmeans cluster to be used to compare against svd for Africa

#to download the data table: http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/X/32.83333/48.33333/RANGEEDGES/Y/2.749998/15.0/RANGEEDGES/T/monthlyAverage%5BX/Y%5D%5BT%5D3/k-means136/.Ts/ngridtable/ngridtable/3+ncoltable.html

#Sample Usage
#/data4/ErosionMapping/scripts/./get_kmeans_cluster_dataIRI.sh /data4/ErosionMapping/IRI_kmeans_cluster_results/ethiopia

OutputDir=$1

#downloads the ArcInfo Header ASCII file
#curl -o $OutputDir/trmm_kmeans_africa.asc http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/X/-20/60/RANGEEDGES/Y/-40/40/RANGEEDGES/T/monthlyAverage%5BX/Y%5D%5BT%5D3/k-means136/.clusters/%5BX+Y%5D/arcinfo.asc
curl -o $OutputDir/trmm_kmeans_ethiopia.asc http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/X/32.83333/48.33333/RANGEEDGES/Y/2.749998/15.0/RANGEEDGES/T/monthlyAverage%5BX/Y%5D%5BT%5D3/k-means136/.clusters/%5BX+Y%5D/arcinfo.asc

#downloads a text version of the map
#curl -o $OutputDir/trmm_cluster_layout_africa.tsv http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/X/-20/60/RANGEEDGES/Y/-40/40/RANGEEDGES/T/monthlyAverage%5BX/Y%5D%5BT%5D3/k-means136/.clusters/%5BX%5Ddata.tsv
curl -o $OutputDir/trmm_cluster_layout_ethiopia.tsv http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/X/32.83333/48.33333/RANGEEDGES/Y/2.749998/15.0/RANGEEDGES/T/monthlyAverage%5BX/Y%5D%5BT%5D3/k-means136/.clusters/%5BX%5Ddata.tsv

#summary table of the clusters containing the number of grid cells within each cluster, variance explained by the cluster and the variance not explained by the cluster
#curl -o $OutputDir/trmm_cluster_table_africa.tsv http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/X/-20/60/RANGEEDGES/Y/-40/40/RANGEEDGES/T/monthlyAverage%5BX/Y%5D%5BT%5D3/k-means136/table:/:table/.tsv
curl -o $OutputDir/trmm_cluster_table_ethiopia.tsv http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/X/32.83333/48.33333/RANGEEDGES/Y/2.749998/15.0/RANGEEDGES/T/monthlyAverage%5BX/Y%5D%5BT%5D3/k-means136/table:/:table/.tsv

#downloads a 183x3 table for which each row represents each month from Jan 1998 - Feb 2013 with averaged surface rainfall (mm/day) for each of the 3 clusters
#curl -o $OutputDir/trmm_cluster_data_africa.tsv http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/X/-20/60/RANGEEDGES/Y/-40/40/RANGEEDGES/T/monthlyAverage%5BX/Y%5D%5BT%5D3/k-means136/.Ts/%5Bcluster%5Ddata.tsv
curl -o $OutputDir/trmm_cluster_data_ethiopia.tsv http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/X/32.83333/48.33333/RANGEEDGES/Y/2.749998/15.0/RANGEEDGES/T/monthlyAverage%5BX/Y%5D%5BT%5D3/k-means136/.Ts/%5Bcluster%5Ddata.tsv

#downloads an html containign the average surface rainfall for all 12 months for each cluster
curl "http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/X/32.83333/48.33333/RANGEEDGES/Y/2.749998/15.0/RANGEEDGES/T/monthlyAverage%5BX/Y%5D%5BT%5D3/k-means136/.Ts/ngridtable/ngridtable/3+ncoltable.html?tabopt.N=4&tabopt.1=text&tabopt.2=text&tabopt.3=text&tabopt.4=blankNaN&NaNmarker=&tabtype=html&eol=LF+(unix)&filename=datafile.html" -o $OutputDir/kmeans_monAvg_rainfall.txt

#creates and array in which each index is a line
i=1
for newWord in $(cat $OutputDir/kmeans_monAvg_rainfall.txt); do
	newWords[$i]=$newWord
	i=$((i+1))
done

#displays the array length
len=${#newWords[@]}
numLines=$(echo "$len + 0" | bc)
#echo Number of elements in the array ${#newWords5[@]} 

#IRI expert code to acquire the kmeans rainfall measurements
echo expert SOURCES .NASA .GES-DAAC .TRMM_L3 .TRMM_3B42 .v7 .daily .precipitation T monthlyAverage X 32.83333 48.33333 RANGEEDGES Y 2.749998 15.0 RANGEEDGES [X Y][T]3 k-means136 .Ts ngridtable ngridtable >> $OutputDir/kmeans_monAvg_rainfall.csv
#IRI link to acquire the kmeans
echo ${newWords[17]} | sed 's/\(^.*"\)\(.*\)\(".*$\)/\2/' >> $OutputDir/kmeans_monAvg_rainfall.csv
#column names
echo cluster,Time,Surface Rain from all Satellite and Surface >> $OutputDir/kmeans_monAvg_rainfall.csv
echo ids,months since 1998,mm/day >> $OutputDir/kmeans_monAvg_rainfall.csv

j=1
k=2

while [ $j -lt $numLines ] 
do 
	word1=${newWords[j]}${newWords[k]}
	#echo $word1
	
	#initializes a variable that extracts the first few characters in the string
	initial=$(echo $word1 | sed 's/.//9g')
	#echo $initial

	if [ $initial == "<tr><td>" ]; then
		word2=$(echo $word1 | sed 's/<\/td><td>/,/;s/<tr><td>//;s/<\/td><td>/,/;s/<\/td><\/tr>//1')
		echo $word2 >> $OutputDir/kmeans_monAvg_rainfall.csv
	fi

	j=$((j+1))
	k=$((k+1))
done
