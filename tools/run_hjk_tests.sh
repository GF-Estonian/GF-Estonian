#!/bin/bash

tests=../tests/
g=../estonian/

# Warning: overwrites gold files

rm ${tests}/hjk_type.gold.csv
rm ${tests}/mkN.gold.csv
rm ${tests}/mkV.gold.csv
rm ${tests}/lexicon.gold.csv
rm ${tests}/numeral.gold.csv

# Nouns and adjective
for file in $(ls ${tests}/hjk_type*.csv | grep -v "\.gold\.")
do
	type=$(basename "$file")
	type="${type%%.*}"
	echo $type
	# Compute using the 1 or 2 argument oper
	cat ${tests}/${type}.csv | python cc.py -r ${g}/HjkEst.gf --oper ${type} | gf --run > ${tests}/${type}.gold.csv

	# Compute using the 1-arg oper
	cat ${tests}/${type}.csv | sed "s/,.*//" | python cc.py -r ${g}/HjkEst.gf --oper "hjk_type" | gf --run >> ${tests}/hjk_type.gold.csv

	echo "Testing ParadigmsEst: mkN"
	cat ${tests}/${type}.csv | sed "s/,.*//" | python cc.py -r ${g}/ParadigmsEst.gf --oper "mkN" | gf --run >> ${tests}/mkN.gold.csv
done

# Verbs
for file in $(ls ${tests}/ts_type*.csv)
do
	type=$(basename "$file")
	type="${type%%.*}"
	echo $type

	# echo "Testing ParadigmsEst: mkV"
	cat ${tests}/${type}.csv | sed "s/,.*//" | python cc.py -r ${g}/ParadigmsEst.gf --oper "mkV" | gf --run >> ${tests}/mkV.gold.csv
done

# Lexicon
for oper in $(cat ${g}/LexiconEst.gf | grep -v "^ *--" | grep "=" | sed "s/=.*//" | grep "_" | sed "s/ //g" | sort)
do
	echo $oper
	echo | python cc.py -r ${g}/LexiconEst.gf --oper "$oper" | gf --run >> ${tests}/lexicon.gold.csv
done

# Numerals
for oper in $(cat ${g}/NumeralEst.gf | egrep "(yksN|kymmeN|sadaN|tuhatN|kymmendN|tuhattaN|n[0-9]) *=" | sed "s/=.*//" | sed "s/ //g")
do
	echo $oper
	echo | python cc.py -r ${g}/NumeralEst.gf --oper "$oper" | gf --run >> ${tests}/numeral.gold.csv
done
