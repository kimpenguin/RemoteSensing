#!/bin/bash
# script downloads all the eigen values for the trmm data for Africa
# follow up because of the # of points to process, only small regions of africa can be processed by iri

#Stores the time series in output directory specified by user

#Sample Usage
#/data4/ErosionMapping/scripts/./get_svd_dataIRI.sh /data4/ErosionMapping/IRI_SVD_results/ethiopia 10

OutputDir=$1
numEV=$2

#checks to see if user entered number of ev they want to download otherwise sets it to zero to download all available.
if [ -z "$numEV" ] ; then
	numEV=0
fi

#africa
#curl http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/T/monthlyAverage/X/-20/60/RANGEEDGES/Y/-40/40/RANGEEDGES/%7BY/cosd%7D%5BX/Y%5D%5BT%5Dsvd/.Ss/downloadsarcinfo.html?missing_value=-9999 -o $OutputDir/svd_downloads.txt
#X 20 52
#curl http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/T/monthlyAverage/X/20/52/RANGEEDGES/Y/-36/38/RANGEEDGES/%7BY/cosd%7D%5BX/Y%5D%5BT%5Dsvd/.Ss/downloadsarcinfo.html?missing_value=-9999 -o $OutputDir/svd_downloads.txt
#X -20 20
#curl http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/T/monthlyAverage/X/-20/20/RANGEEDGES/Y/-36/38/RANGEEDGES/%7BY/cosd%7D%5BX/Y%5D%5BT%5Dsvd/.Ss/downloadsarcinfo.html?missing_value=-9999 -o $OutputDir/svd_downloads.txt
#X 36 52
#curl http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/T/monthlyAverage/X/36/52/RANGEEDGES/Y/1/13/RANGEEDGES/%7BY/cosd%7D%5BX/Y%5D%5BT%5Dsvd/.Ss/downloadsarcinfo.html?missing_value=-9999 -o $OutputDir/svd_downloads.txt
#ethiopia
curl http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/T/monthlyAverage/X/32.83333/48.33333/RANGEEDGES/Y/2.749998/15.0/RANGEEDGES/%7BY/cosd%7D%5BX/Y%5D%5BT%5Dsvd/.Ss/downloadsarcinfo.html?missing_value=-9999 -o $OutputDir/svd_downloads.txt

##############################################################NORMALIZED EIGENVALUES
#downloading normalized eigenvalues
curl "http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/T/monthlyAverage/X/32.83333/48.33333/RANGEEDGES/Y/2.749998/15.0/RANGEEDGES/%7BY/cosd%7D%5BX/Y%5D%5BT%5Dsvd/evaln/ev+exch/2+ncoltable.html?tabopt.N=3&tabopt.1=text&tabopt.2=text&tabopt.3=skipanyNaN&NaNmarker=&tabtype=html&eol=LF+(unix)&filename=datafile.htm" -o $OutputDir/svd_normalized_evs.txt

#creates and array in which each index is a line
i=1
for newWord in $(cat $OutputDir/svd_normalized_evs.txt); do
	newWords[$i]=$newWord
	i=$((i+1))
done

#displays the array length
len=${#newWords[@]}
numLines=$(echo "$len + 0" | bc)
#echo Number of elements in the array ${#newWords[@]} 

#IRI expert code to acquire the normalized eigenvalues
echo expert SOURCES .${newWords[9]} .${newWords[10]} .${newWords[11]} .${newWords[12]} .${newWords[13]} .${newWords[14]} .${newWords[15]} T monthlyAverage X 32.83333 48.33333 RANGEEDGES Y 2.749998 15.0 RANGEEDGES {Y cosd}[X Y][T]svd evaln ev exch >> $OutputDir/svd_normalized_eigenvalues.csv
#IRI link to acquire the normalized eigenvalues
echo ${newWords[21]} | sed 's/\(^.*"\)\(.*\)\(".*$\)/\2/' >> $OutputDir/svd_normalized_eigenvalues.csv
#column names
echo ev,normalized eigenvalues >> $OutputDir/svd_normalized_eigenvalues.csv

j=1
while [ $j -lt $numLines ] 
do 
	word1=${newWords[j]}

	#initializes a variable that extracts the first few characters in the string
	initial=$(echo $word1 | sed 's/.//9g')
	#echo $initial

	if [ $initial == "<tr><td>" ]; then
		#removes any non-numeric characters, leaving just the index number and the measurement
		word2=$(echo $word1 | sed 's/<[^>]*>//g')
		#echo $word2

		#replaces the first instance of a decimal point with a comma
		word3=$(echo $word2 | sed 's/\./,/1')
		#adds the modified line to the output text file on a new line
		echo $word3 >> $OutputDir/svd_normalized_eigenvalues.csv
	fi

	j=$((j+1))
done

##############################################################STRUCTURES
#downloading structures
curl http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/T/monthlyAverage/X/32.83333/48.33333/RANGEEDGES/Y/2.749998/15.0/RANGEEDGES/%7BY/cosd%7D%5BX/Y%5D%5BT%5Dsvd/.Ss/%5BX%5Ddata.tsv -o $OutputDir/svd_structures.tsv

##############################################################SINGULAR VALUES
#downloading singular values
#http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/T/monthlyAverage/X/32.83333/48.33333/RANGEEDGES/Y/2.749998/15.0/RANGEEDGES/%7BY/cosd%7D%5BX/Y%5D%5BT%5Dsvd/.sv/%5Bev%5Ddata.tsv
curl "http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/T/monthlyAverage/X/32.83333/48.33333/RANGEEDGES/Y/2.749998/15.0/RANGEEDGES/%7BY/cosd%7D%5BX/Y%5D%5BT%5Dsvd/sv/ev+exch/2+ncoltable.html?tabopt.N=3&tabopt.1=text&tabopt.2=text&tabopt.3=skipanyNaN&NaNmarker=&tabtype=html&eol=LF+(unix)&filename=datafile.html" -o $OutputDir/svd_singular_values.txt

#creates and array in which each index is a line
i=1
for newWord2 in $(cat $OutputDir/svd_singular_values.txt); do
	newWords2[$i]=$newWord2
	i=$((i+1))
done

#displays the array length
len=${#newWords2[@]}
numLines=$(echo "$len + 0" | bc)
#echo Number of elements in the array ${#newWords2[@]} 

#IRI expert code to acquire the singular values
echo expert SOURCES .${newWords2[9]} .${newWords2[10]} .${newWords2[11]} .${newWords2[12]} .${newWords2[13]} .${newWords2[14]} .${newWords2[15]} T monthlyAverage X 32.83333 48.33333 RANGEEDGES Y 2.749998 15.0 RANGEEDGES {Y cosd}[X Y][T]svd sv ev exch >> $OutputDir/svd_singular_values.csv
#IRI link to acquire the singular eigenvalues
echo ${newWords2[21]} | sed 's/\(^.*"\)\(.*\)\(".*$\)/\2/' >> $OutputDir/svd_singular_values.csv
#column names
echo ev,singular values >> $OutputDir/svd_singular_values.csv


j=1
while [ $j -lt $numLines ] 
do 
	word1=${newWords2[j]}

	#initializes a variable that extracts the first few characters in the string
	initial=$(echo $word1 | sed 's/.//9g')
	#echo $initial

	if [ $initial == "<tr><td>" ]; then
		#removes any non-numeric characters, leaving just the index number and the measurement
		word2=$(echo $word1 | sed 's/<[^>]*>//g')
		#echo $word2

		#replaces the first instance of a decimal point with a comma
		word3=$(echo $word2 | sed 's/\./,/1')
		#adds the modified line to the output text file on a new line
		echo $word3 >> $OutputDir/svd_singular_values.csv
	fi

	j=$((j+1))
done

##############################################################TIME SERIES
#downloading time series
curl "http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/T/monthlyAverage/X/32.83333/48.33333/RANGEEDGES/Y/2.749998/15.0/RANGEEDGES/%7BY/cosd%7D%5BX/Y%5D%5BT%5Dsvd/Ts/ngridtable/3+ncoltable.html?tabopt.N=4&tabopt.1=text&tabopt.2=text&tabopt.3=text&tabopt.4=blankNaN&NaNmarker=&tabtype=html&eol=LF+(unix)&filename=datafile.html" -o $OutputDir/svd_time_series.txt

#creates and array in which each index is a line
i=1
for newWord5 in $(cat $OutputDir/svd_time_series.txt); do
	newWords5[$i]=$newWord5
	i=$((i+1))
done

#displays the array length
len=${#newWords5[@]}
numLines=$(echo "$len + 0" | bc)
#echo Number of elements in the array ${#newWords5[@]} 

#IRI expert code to acquire the normalized eigenvalues
echo expert SOURCES .${newWords5[9]} .${newWords5[10]} .${newWords5[11]} .${newWords5[12]} .${newWords5[13]} .${newWords5[14]} .${newWords5[15]} T monthlyAverage X 32.83333 48.33333 RANGEEDGES Y 2.749998 15.0 RANGEEDGES {Y cosd}[X Y][T]svd Ts ngridtable >> $OutputDir/svd_time_series.csv
#IRI link to acquire the normalized eigenvalues
echo ${newWords5[22]} | sed 's/\(^.*"\)\(.*\)\(".*$\)/\2/' >> $OutputDir/svd_time_series.csv
#column names
echo Time,ev,time series >> $OutputDir/svd_time_series.csv
echo months since 1998, ,mm/day >> $OutputDir/svd_time_series.csv

j=1
k=2
while [ $j -lt $numLines ] 
do 
	word1=${newWords5[j]}${newWords5[k]}
	#echo $word1
	
	#initializes a variable that extracts the first few characters in the string
	initial=$(echo $word1 | sed 's/.//9g')
	#echo $initial

	if [ $initial == "<tr><td>" ]; then
		word2=$(echo $word1 | sed 's/<\/td><td>/,/;s/\./,/;s/<tr><td>//;s/<\/td><td>//;s/<\/td><\/tr>//1')
		echo $word2 >> $OutputDir/svd_time_series.csv
	fi

	j=$((j+1))
	k=$((k+1))
done
##############################################################TOTAL VARIANCE
#donwloading total variance
curl "http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/T/monthlyAverage/X/32.83333/48.33333/RANGEEDGES/Y/2.749998/15.0/RANGEEDGES/%7BY/cosd%7D%5BX/Y%5D%5BT%5Dsvd/vartot/ngridtable/1+ncoltable.html?tabopt.N=2&tabopt.1=text&tabopt.2=skipanyNaN&NaNmarker=&tabtype=html&eol=LF+(unix)&filename=datafile.html" -o $OutputDir/svd_total_variance.txt

#creates and array in which each index is a line
i=1
for newWord4 in $(cat $OutputDir/svd_total_variance.txt); do
	newWords4[$i]=$newWord4
	i=$((i+1))
done

#displays the array length
len=${#newWords4[@]}
numLines=$(echo "$len + 0" | bc)
#echo Number of elements in the array ${#newWords4[@]} 

#IRI expert code to acquire the weights
echo expert SOURCES .${newWords4[9]} .${newWords4[10]} .${newWords4[11]} .${newWords4[12]} .${newWords4[13]} .${newWords4[14]} .${newWords4[15]} T monthlyAverage X 32.83333 48.33333 RANGEEDGES Y 2.749998 15.0 RANGEEDGES {Y cosd}[X Y][T]svd vartot ngridtable >> $OutputDir/svd_total_variance.csv
#IRI link to acquire the weights
echo ${newWords4[20]} | sed 's/\(^.*"\)\(.*\)\(".*$\)/\2/' >> $OutputDir/svd_total_variance.csv
#column names
echo total variance >> $OutputDir/svd_total_variance.csv

	word1=${newWords4[27]}
	word2=$(echo $word1 | sed 's/<[^>]*>//g')
	echo $word2 >> $OutputDir/svd_total_variance.csv

##############################################################WEIGHTS
#downloading weights
curl "http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/T/monthlyAverage/X/32.83333/48.33333/RANGEEDGES/Y/2.749998/15.0/RANGEEDGES/%7BY/cosd%7D%5BX/Y%5D%5BT%5Dsvd/W/Y+exch/2+ncoltable.html?tabopt.N=3&tabopt.1=text&tabopt.2=text&tabopt.3=skipanyNaN&NaNmarker=&tabtype=html&eol=LF+(unix)&filename=datafile.html" -o $OutputDir/svd_weights.txt

#creates and array in which each index is a line
i=1
for newWord3 in $(cat $OutputDir/svd_weights.txt); do
	newWords3[$i]=$newWord3
	i=$((i+1))
done

#displays the array length
len=${#newWords3[@]}
numLines=$(echo "$len + 0" | bc)
#echo Number of elements in the array ${#newWords3[@]} 

#IRI expert code to acquire the weights
echo expert SOURCES .${newWords3[9]} .${newWords3[10]} .${newWords3[11]} .${newWords3[12]} .${newWords3[13]} .${newWords3[14]} .${newWords3[15]} T monthlyAverage X 32.83333 48.33333 RANGEEDGES Y 2.749998 15.0 RANGEEDGES {Y cosd}[X Y][T]svd W Y exch >> $OutputDir/svd_weights.csv
#IRI link to acquire the weights
echo ${newWords3[20]} | sed 's/\(^.*"\)\(.*\)\(".*$\)/\2/' >> $OutputDir/svd_weights.csv
#column names
echo Latitude,weights >> $OutputDir/svd_weights.csv
echo degree_north >> $OutputDir/svd_weights.csv


j=1
while [ $j -lt $numLines ] 
do 
	word1=${newWords3[j]}

	#initializes a variable that extracts the first few characters in the string
	initial=$(echo $word1 | sed 's/.//9g')
	#echo $initial

	if [ $initial == "<tr><td>" ]; then
		#removes any non-numeric characters, leaving just the index number and the measurement
		word2=$(echo $word1 | sed 's/<[^>]*>//g')
		#echo $word2

		#replaces the first instance of a N with N and a comma
		word3=$(echo $word2 | sed 's/\N/N,/1')
		#adds the modified line to the output text file on a new line
		echo $word3 >> $OutputDir/svd_weights.csv
	fi

	j=$((j+1))
done


##############################################################DOWNLOADING ASCII II FILES
i=1
for newWord6 in $(cat $OutputDir/svd_downloads.txt); do
	newWords6[$i]=$newWord6
	i=$((i+1))
done
#displays the array length
echo Number of elements in the array ${#newWords6[@]} 
totEV=${newWords6[313]}
echo number of available evs for download $totEV
echo user has chosen to download $numEV evs

#based on user input, if they have chosen to download all available evs, loops through and downloads all evs
j=1
if [ $numEV == 0 ]; then
while [ $j -le $totEV ] 
do 
	echo downloading all available
	echo curl http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/T/monthlyAverage/X/-20/60/RANGEEDGES/Y/-40/40/RANGEEDGES/%7BY/cosd%7D%5BX/Y%5D%5BT%5Dsvd/.Ss/ev+%28$j.%29+VALUE/-9999/setmissing_value/%5BX+Y%5D/arcinfo.asc?filename=trmm_ev_"$j"_africa.asc -o $OutputDir/trmm_ev_"$j"_africa.asc
	j=$((j+1))
done

else
while [ $j -le $numEV ] 
do 
	echo downloading just $numEV
	#africa
	#curl http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/T/monthlyAverage/X/-20/60/RANGEEDGES/Y/-40/40/RANGEEDGES/%7BY/cosd%7D%5BX/Y%5D%5BT%5Dsvd/.Ss/ev+%28$j.%29+VALUE/-9999/setmissing_value/%5BX+Y%5D/arcinfo.asc?filename=trmm_ev_"$j"_africa -o $OutputDir/trmm_ev_"$j"_africa
	#curl http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/T/monthlyAverage/X/20/52/RANGEEDGES/Y/-36/38/RANGEEDGES/%7BY/cosd%7D%5BX/Y%5D%5BT%5Dsvd/.Ss/ev+%28$j.%29+VALUE/-9999/setmissing_value/%5BX+Y%5D/arcinfo.asc?filename=trmm_ev_"$j"_africa -o $OutputDir/trmm_ev_"$j"_X2052
	#curl http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/T/monthlyAverage/X/-20/20/RANGEEDGES/Y/-36/38/RANGEEDGES/%7BY/cosd%7D%5BX/Y%5D%5BT%5Dsvd/.Ss/ev+%28$j.%29+VALUE/-9999/setmissing_value/%5BX+Y%5D/arcinfo.asc?filename=trmm_ev_"$j"_africa -o $OutputDir/trmm_ev_"$j"_X-2020
	#curl http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/T/monthlyAverage/X/36/52/RANGEEDGES/Y/1/13/RANGEEDGES/%7BY/cosd%7D%5BX/Y%5D%5BT%5Dsvd/.Ss/ev+%28$j.%29+VALUE/-9999/setmissing_value/%5BX+Y%5D/arcinfo.asc?filename=trmm_ev_"$j"_africa -o $OutputDir/trmm_ev_"$j"_X3652

	#ethiopia
	curl http://iridl.ldeo.columbia.edu/expert/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42/.v7/.daily/.precipitation/T/monthlyAverage/X/32.83333/48.33333/RANGEEDGES/Y/2.749998/15.0/RANGEEDGES/%7BY/cosd%7D%5BX/Y%5D%5BT%5Dsvd/.Ss/ev+%28$j.%29+VALUE/-9999/setmissing_value/%5BX+Y%5D/arcinfo.asc?filename=trmm_ev_"$j"_africa -o $OutputDir/trmm_ev_"$j"_ethiopia.asc



	j=$((j+1))	
done
fi


