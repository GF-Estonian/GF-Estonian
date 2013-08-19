
tests=../tests/
g=../estonian/

# Warning: overwrites gold files

cat ${tests}/forms_six.csv | python cc.py --oper hjk_nForms6 --resource ${g}/HjkEst.gf | gf --run > ${tests}/forms_six.gold.csv

for type in "hjk_type_I_koi" "hjk_type_II_ema" "hjk_type_III_ratsu" "hjk_type_IVa_aasta"
do
	cat ${tests}/${type}.csv | python cc.py -r ${g}/HjkEst.gf --oper ${type} | gf --run > ${tests}/${type}.gold.csv
done
