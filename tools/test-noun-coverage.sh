#/bin/sh

gold=../data/nouns.6forms.csv
out=nouns.6forms.gf.csv
diff=nouns.6forms.diff.csv
coverage=nouns.coverage.txt

g=../estonian/
cat ${gold} |\
sed "s/,.*//" |\
python cc.py -r ${g}/HjkEst.gf --oper "hjk_type" |\
gf --run |\
perl -nal -F",\s+" -e 'print "$F[0], $F[1], $F[2], $F[3], $F[15], $F[16]"' > ${out}

./diff-list-set.py ${gold} ${out} | tee ${diff} | cut -f2 | sort | uniq -c | sort -nr | tee ${coverage}

total=`cat ${out} | wc -l`
correct=`head -1 ${coverage} | sed "s/ *//g"`
result=`echo "scale=4; ${correct}/${total}" | bc`

echo "Coverage: ${correct} out of ${total} = ${result}"

diff nouns.coverage.prev ${coverage}
