#/bin/bash

# Noun smart paradigm correctness testing script.
# Runs tests for 1,2,3,4 arguments.
#
# Usage examples:
#
# ./test-mkN.bash ../data/nouns.6forms.csv
# ./test-mkN.bash ../data/adj.6forms.csv
#
# Kaarel Kaljurand
# 2013-10-09

# Note about rewriting.
# Rewrite the base forms that use the parallel forms notation because
# such |-containing forms are not handled by the opers, so the
# results would be misleading.
# The rewriting preserves just the last parallel form and
# makes the assumption that the correct forms align
# (palk, palga|palgi, palka|palki) but this might not always hold.
# This affects 330 forms in case the 1st 3 forms are considered.
# With just the 1st form (nominative) there are just a couple that contain the '|'.

sed=/bin/sed
g=../estonian/

gold=""

if [ $# -eq 1 ]
then
	gold=$1
else
	echo "Usage: test-mkN.bash <6-form-file>"
	exit
fi

pattern[1]='(@F[0])'
pattern[2]='(@F[0..1])'
pattern[3]='(@F[0..2])'
pattern[4]='(@F[0..2], @F[5])'

for i in `seq 1 4`
do
	pat="${pattern[$i]}"
	echo "$i-arg pattern: $pat"
	out="mkN${i}.6forms.csv"
	diff="mkN${i}.diff.txt"
	coverage="mkN${i}.coverage.txt"

	# Based on the pattern, extract mkN input forms from the gold standard.
	cat ${gold} |\
	perl -nal -F",\s+" -e "print join ', ', ${pat}" |\
	# Rewriting
	$sed "s/[^ ]*|//g" |\
	python cc.py -r ${g}/ParadigmsEst.gf --oper "mkN" |\
	gf --run |\
	perl -nal -F",\s+" -e "print join ', ', (@F[0..3], @F[15..16])" > ${out}

	# Compare the mkN output with the gold standard
	python diff-list-set.py ${gold} ${out} | tee ${diff} | cut -f2 | sort | uniq -c | sort -nr > ${coverage}

	total=`cat ${out} | wc -l`
	correct=`head -1 ${coverage} | sed "s/ *//g"`
	result=`echo "scale=4; ${correct}/${total}" | bc`
	echo "Coverage: ${correct} out of ${total} = ${result}" >> ${coverage}
	cat ${coverage}
done
