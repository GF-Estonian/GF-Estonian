#/bin/sh

gold=verbs.8forms.csv
out=verbs.8forms.gf.csv
diff=verbs.8forms.diff.csv
coverage=coverage.txt

g=../estonian/
cat ${gold} |\
sed "s/,.*//" |\
python cc.py -r ${g}/ParadigmsEst.gf --oper "mkV" |\
gf --run |\
perl -nal -F",\s+" -e 'print "$F[2], $F[0], $F[9], $F[31], $F[26], $F[15], $F[36], $F[65]"' > ${out}
#python cc.py -r ${g}/ParadigmsEst.gf --oper "vForms1" |\
#gf --run > ${out}


./diff-list-set.py ${gold} ${out} | tee ${diff} | cut -f2 | sort | uniq -c | sort -nr | tee ${coverage}

total=`cat ${out} | wc -l`
correct=`head -1 ${coverage} | sed "s/ *//g"`
result=`echo "scale=3; ${correct}/${total}" | bc`

echo "Coverage: ${correct} out of ${total} = ${result}"

diff coverage.prev ${coverage}
