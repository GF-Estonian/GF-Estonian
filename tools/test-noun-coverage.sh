#/bin/sh

gold=../data/nouns.6forms.csv
out=nouns.6forms.gf.csv
diff=nouns.6forms.diff.csv
#coverage=nouns.coverage.txt
#coverage=nouns2.coverage.txt
#coverage=nouns3.coverage.txt
coverage=nouns4.coverage.txt
#incorrect=nouns.incorrect.txt
#incorrect=nouns2.incorrect.txt
#incorrect=nouns3.incorrect.txt
incorrect=nouns4.incorrect.txt

g=../estonian/
cat ${gold} |\
#sed "s/,.*//" |\
#sed -r 's/([^,]*, [^,]*),.*/\1/' |\
sed -r 's/([^,]*, [^,]*, [^,]*),.*/\1/' |\
#sed -r 's/([^,]*,) ([^,]*,) ([^,]*,) [^,]*, [^,]*, (.*)$/\1 \2 \3 \4/' |\
# Rewrite the base forms that use the parallel forms notation because
# such |-containing forms are not handled by the opers, so the
# results would be misleading.
# The rewriting preserves just the last parallel form and
# makes the assumption that the correct forms align
# (palk, palga|palgi, palka|palki) but this might not always hold.
# This affects 330 forms in case the 1st 3 forms are considered.
# With just the 1st form (nominative) there are just a couple that contain the '|'.
#sed "s/|[^,]*//g" |\
sed "s/[^ ]*|//g" |\
#python cc.py -r ${g}/HjkEst.gf --oper "hjk_type" |\
python cc.py -r ${g}/ParadigmsEst.gf --oper "mk3N" |\
gf --run |\
perl -nal -F",\s+" -e 'print "$F[0], $F[1], $F[2], $F[3], $F[15], $F[16]"' > ${out}

./diff-list-set.py ${gold} ${out} | tee ${diff} | cut -f2 | sort | uniq -c | sort -nr | tee ${coverage}

total=`cat ${out} | wc -l`
correct=`head -1 ${coverage} | sed "s/ *//g"`
result=`echo "scale=4; ${correct}/${total}" | bc`

#produce list of incorrect results
egrep [0-9] ${diff} | cut -f1 > ${incorrect}

echo "Coverage: ${correct} out of ${total} = ${result}"

diff nouns3.coverage.prev ${coverage}
