#!/bin/bash

tests=../tests/
g=../estonian/

# Warning: overwrites gold files

cat ${tests}/forms_six.csv | python cc.py --oper hjk_nForms6 --resource ${g}/HjkEst.gf | gf --run > ${tests}/forms_six.gold.csv
cat ${tests}/forms_six.csv | python cc.py --oper mk6N --resource ${g}/ParadigmsEst.gf | gf --run > ${tests}/paradigms_mk6N.gold.csv
cat ${tests}/nouns.csv | python cc.py -r ${g}/ParadigmsEst.gf --oper "mkN" | gf --run > ${tests}/nouns.gold.csv

rm ${tests}/hjk_type.gold.csv
rm ${tests}/mkN.gold.csv
rm ${tests}/lexicon.gold.csv
rm ${tests}/numeral.gold.csv

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

for file in $(ls ${tests}/ts_type*.csv)
do
	type=$(basename "$file")
	type="${type%%.*}"
	echo $type

	# echo "Testing ParadigmsEst: mkV"
	cat ${tests}/${type}.csv | sed "s/,.*//" | python cc.py -r ${g}/ParadigmsEst.gf --oper "mkV" | gf --run >> ${tests}/mkV.gold.csv
done

# TODO: cover also Adv, V, etc.
for oper in $(cat ${g}/LexiconEst.gf | grep -v "^ *--" | grep "_[NA][0-9]* *=" | sed "s/=.*//" | sed "s/ //g")
do
	echo $oper
	echo | python cc.py -r ${g}/LexiconEst.gf --oper "$oper" | gf --run >> ${tests}/lexicon.gold.csv
done

for oper in $(cat ${g}/NumeralEst.gf | egrep "(yksN|kymmeN|sadaN|tuhatN|kymmendN|tuhattaN|n[0-9]) *=" | sed "s/=.*//" | sed "s/ //g")
do
	echo $oper
	echo | python cc.py -r ${g}/NumeralEst.gf --oper "$oper" | gf --run >> ${tests}/numeral.gold.csv
done
