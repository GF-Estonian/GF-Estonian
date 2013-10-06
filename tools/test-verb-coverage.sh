#/bin/sh

gold=verbs.8forms.csv
out=verbs.8forms.gf.csv
diff=verbs.8forms.diff.csv
coverage=verbs.coverage.txt
incorrect=verbs.incorrect.txt
#coverage=coverage2.txt
#coverage=coverage3.txt
#coverage=coverage4.txt

g=../estonian/
cat ${gold} |\
sed "s/,.*//" |\
#sed -r 's/([^,]*, [^,]*),.*/\1/' |\
#sed -r 's/([^,]*, [^,]*, [^,]*),.*/\1/' |\
#sed -r 's/([^,]*, [^,]*, [^,]*, [^,]*),.*/\1/' |\
python cc.py -r ${g}/ParadigmsEst.gf --oper "mkV" |\
gf --run |\
perl -nal -F",\s+" -e 'print "$F[2], $F[0], $F[9], $F[30], $F[26], $F[15], $F[38], $F[39]"' > ${out}


./diff-list-set.py ${gold} ${out} | tee ${diff} | cut -f2 | sort | uniq -c | sort -nr | tee ${coverage}

total=`cat ${out} | wc -l`
correct=`head -1 ${coverage} | sed "s/ *//g"`
result=`echo "scale=3; ${correct}/${total}" | bc`

#produce list of incorrect results
egrep [0-9] ${diff} | tr -d '0-9\- \t' > ${incorrect} 

echo "Coverage: ${correct} out of ${total} = ${result}"

diff coverage.prev ${coverage}
