#!/bin/bash

tests=../tests/
g=../estonian/

# Warning: overwrites gold files

cat ${tests}/forms_six.csv | python cc.py --oper hjk_nForms6 --resource ${g}/HjkEst.gf | gf --run > ${tests}/forms_six.gold.csv

for file in $(ls ${tests}/hjk_type*.csv | grep -v "\.gold\.")
do
	type=$(basename "$file")
	type="${type%%.*}"
	echo $type
	cat ${tests}/${type}.csv | python cc.py -r ${g}/HjkEst.gf --oper ${type} | gf --run > ${tests}/${type}.gold.csv
done
