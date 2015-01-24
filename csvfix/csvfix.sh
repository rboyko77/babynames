#!/bin/sh
#
# csvfix.sh: standardize babydb csv files before handing them over to R program 
# version - 1.0
# author: Robert Boyko - Jan 23/15
#
# usage: csvfix.sh genderStr
#   where genderStr is a string identifying the csv files we want to process
#
#   eg csvfix.sh Boys
#

case $# in
    0) echo 'usage: csvfix.sh [genderStr]' ;
       exit ;;
    1) gender=$1 ;;
    *) echo 'usage: csvfix.sh [genderStr]' ;
       exit ;;
esac

# create empty output directory
\rm -rf final
mkdir  final

for i in `ls ../babydb/*/intermediates/csv/*$gender*.csv`  
do
	echo process $i
	cp $i tmp1

	# Put in new line char
	LC_CTYPE=C  tr -s "\015" "\012" < tmp1 > tmp2 

	# Find names containing non-ascii chars and delete them.
	perl -i.bak -ne 'print unless(/[^[:ascii:]]/)' tmp2

	# Note: I will investigate nicolas-grekas/Patchwork-UTF8 at github
	# for a better solution in subsequent versions of this software. 

	# Only keep lines that have a frequency number in column 1
	# This addresses the problem of variable number of header lines
	# and possibly other anomalies.
	awk '/^[0-9]/ {print $0}' tmp2 > tmp3 

	# Convert any same names with mixed case to lower case
	# Yes, these can exist in the data I pull from the government :(
	tr '[:upper:]' '[:lower:]' < tmp3 > tmp4 

	# Now we have add to add the columns where the names are the same
	awk 'BEGIN { FS = "," } {
		arr[$2]+=$1} END {for (i in arr) {print arr[i]",",i}}
		' tmp4 > tmp5
	
	# Sort them and append a standard title for each column
	sort -u -t',' -k2,2 tmp5 > tmp6
	echo "Freq, Name" | cat - tmp6 > tmp7
	
	# 
	mv tmp7 final/`basename $i`

done

\rm -rf tmp1 tmp2 tmp2.bak tmp3 tmp4 tmp5 tmp6

exit 0
