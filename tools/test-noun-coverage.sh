#/bin/sh

gold=../data/nouns.6forms.csv
out1=nouns.6forms.gf.csv
out2=nouns2.6forms.gf.csv
out3=nouns3.6forms.gf.csv
out4=nouns4.6forms.gf.csv

diff1=nouns.6forms.diff.csv
diff2=nouns2.6forms.diff.csv
diff3=nouns3.6forms.diff.csv
diff4=nouns4.6forms.diff.csv

coverage1=nouns.coverage.txt
coverage2=nouns2.coverage.txt
coverage3=nouns3.coverage.txt
coverage4=nouns4.coverage.txt

incorrect1=nouns.incorrect.txt
incorrect2=nouns2.incorrect.txt
incorrect3=nouns3.incorrect.txt
incorrect4=nouns4.incorrect.txt

g=../estonian/


# # 1-arg
# cat ${gold} |\
# gsed "s/,.*//" |\
# gsed "s/[^ ]*|//g" |\
# python cc.py -r ${g}/ParadigmsEst.gf --oper "mkN" |\
# gf --run |\
# perl -nal -F",\s+" -e 'print "$F[0], $F[1], $F[2], $F[3], $F[15], $F[16]"' > ${out1}

# ./diff-list-set.py ${gold} ${out1} | tee ${diff1} | cut -f2 | sort | uniq -c | sort -nr | tee ${coverage1}


# total=`cat ${out1} | wc -l`
# correct=`head -1 ${coverage1} | sed "s/ *//g"`
# result=`echo "scale=4; ${correct}/${total}" | bc` 
# echo "Coverage: ${correct} out of ${total} = ${result}" >> ${coverage1}



# #2-arg
# cat ${gold} |\
# gsed -r 's/([^,]*, [^,]*),.*/\1/' |\
# gsed "s/[^ ]*|//g" |\
# python cc.py -r ${g}/ParadigmsEst.gf --oper "mkN" |\
# gf --run |\
# perl -nal -F",\s+" -e 'print "$F[0], $F[1], $F[2], $F[3], $F[15], $F[16]"' > ${out2}

# ./diff-list-set.py ${gold} ${out2} | tee ${diff2} | cut -f2 | sort | uniq -c | sort -nr | tee ${coverage2}

# total=`cat ${out2} | wc -l`
# correct=`head -1 ${coverage2} | sed "s/ *//g"`
# result=`echo "scale=4; ${correct}/${total}" | bc`
# echo "Coverage: ${correct} out of ${total} = ${result}" >> ${coverage2}

# #3-arg
# cat ${gold} |\
# gsed -r 's/([^,]*, [^,]*, [^,]*),.*/\1/' |\
# gsed "s/[^ ]*|//g" |\
# python cc.py -r ${g}/ParadigmsEst.gf --oper "mkN" |\
# gf --run |\
# perl -nal -F",\s+" -e 'print "$F[0], $F[1], $F[2], $F[3], $F[15], $F[16]"' > ${out3}

# ./diff-list-set.py ${gold} ${out3} | tee ${diff3} | cut -f2 | sort | uniq -c | sort -nr | tee ${coverage3}

# total=`cat ${out3} | wc -l`
# correct=`head -1 ${coverage3} | sed "s/ *//g"`
# result=`echo "scale=4; ${correct}/${total}" | bc`
# echo "Coverage: ${correct} out of ${total} = ${result}" >> ${coverage3}

# #4-arg with pl gen
# cat ${gold} |\
# gsed -r 's/([^,]*,) ([^,]*,) ([^,]*,) [^,]*, ([^,]*), .*$/\1 \2 \3 \4/' |\
# gsed "s/[^ ]*|//g" |\
# python cc.py -r ${g}/ParadigmsEst.gf --oper "mkN" |\
# gf --run |\
# perl -nal -F",\s+" -e 'print "$F[0], $F[1], $F[2], $F[3], $F[15], $F[16]"' > ${out4}

# ./diff-list-set.py ${gold} ${out3} | tee ${diff4} | cut -f2 | sort | uniq -c | sort -nr | tee ${coverage4}

# total=`cat ${out4} | wc -l`
# correct=`head -1 ${coverage4} | sed "s/ *//g"`
# result=`echo "scale=4; ${correct}/${total}" | bc`
# echo "Coverage: ${correct} out of ${total} = ${result}" >> ${coverage4}



#4-arg with pl part
cat ${gold} |\
gsed -r 's/([^,]*,) ([^,]*,) ([^,]*,) [^,]*, [^,]*, (.*)$/\1 \2 \3 \4/' |\
# Rewrite the base forms that use the parallel forms notation because
# such |-containing forms are not handled by the opers, so the
# results would be misleading.
# The rewriting preserves just the last parallel form and
# makes the assumption that the correct forms align
# (palk, palga|palgi, palka|palki) but this might not always hold.
# This affects 330 forms in case the 1st 3 forms are considered.
# With just the 1st form (nominative) there are just a couple that contain the '|'.
#sed "s/|[^,]*//g" |\
gsed "s/[^ ]*|//g" |\
python cc.py -r ${g}/ParadigmsEst.gf --oper "mkN" |\
gf --run |\
perl -nal -F",\s+" -e 'print "$F[0], $F[1], $F[2], $F[3], $F[15], $F[16]"' > ${out4}

./diff-list-set.py ${gold} ${out4} | tee ${diff4} | cut -f2 | sort | uniq -c | sort -nr | tee ${coverage4}

total=`cat ${out4} | wc -l`
correct=`head -1 ${coverage4} | sed "s/ *//g"`
result=`echo "scale=4; ${correct}/${total}" | bc`
echo "Coverage: ${correct} out of ${total} = ${result}" >> ${coverage4}

#produce list of incorrect results
#egrep [0-9] ${diff} | cut -f1 > ${incorrect}

echo "Coverage: ${correct} out of ${total} = ${result}"

diff nouns4.coverage.prev ${coverage4}
