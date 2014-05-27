#/bin/bash

# Smart paradigm correctness testing script.
# Runs tests for 1,2,3,4 arguments.
#
# Usage examples:
#
# ./test-mk.bash N ../data/nouns.6forms.csv
# ./test-mk.bash N ../data/adj.6forms.csv
# ./test-mk.bash V ../data/verbs.8forms.csv
#
# Kaarel Kaljurand
# 2013-10-10

# Note about rewriting.
# Rewrite the base forms that use the parallel forms notation because
# such |-containing forms are not handled by the opers, so the
# results would be misleading.
# The rewriting preserves just the last parallel form and
# makes the assumption that the correct forms align
# (palk, palga|palgi, palka|palki) but this might not always hold.


sed=/bin/sed
g=../estonian/

max=3

class=""
gold=""

if [ $# -eq 2 ]
then
	class=$1
	gold=$2
else
	echo "Usage: test-mk.bash (N|V) <form-file>"
	exit
fi

# Noun/adjective patterns
n_gpat='(@F[0..3], @F[15..16])'
n_pattern[0]='(@F[0])'
n_pattern[1]='(@F[0..1])'
n_pattern[2]='(@F[0..2])'
n_pattern[3]='(@F[0..2], @F[5])'

# Verb patterns
v_gpat='(@F[2], @F[0], @F[9], @F[30], @F[26], @F[15], @F[38..39])'
v_pattern[0]='(@F[0])'
v_pattern[1]='(@F[0..1])'
v_pattern[2]='(@F[0..2])'
v_pattern[3]='(@F[0..3])'

gpat=$n_gpat
# Without double quotes, a space would be interpreted as
# a border between array elements.
pattern=("${n_pattern[@]}")

if [ $class = 'V' ]; then
	gpat=$v_gpat
	pattern=("${v_pattern[@]}")
fi

mk="mk"$class

echo "input: ${gold}"
for i in `seq 0 $max`
do
	pat="${pattern[$i]}"
	hi=$(($i+1))
	echo "${mk} $hi-arg pattern: $pat"
	out="${mk}${hi}.forms.csv"
	diff="${mk}${hi}.diff.txt"
	coverage="${mk}${hi}.coverage.txt"

	# Based on the pattern, extract the input forms from the gold standard.
	cat ${gold} |\
	perl -nal -F",\s+" -e "print join ', ', ${pat}" |\
	# Rewriting
	$sed "s/[^ ]*|//g" |\
	python cc.py -r ${g}/ParadigmsEst.gf --oper ${mk} |\
	gf --run |\
	perl -nal -F",\s+" -e "print join ', ', $gpat" > ${out}

	# Compare the output with the gold standard
	python diff-list-set.py ${gold} ${out} | tee ${diff} | cut -f2 | sort | uniq -c | sort -nr > ${coverage}

	total=`cat ${out} | wc -l`
	correct=`head -1 ${coverage} | sed "s/ *//g"`
	result=`echo "scale=4; ${correct}/${total}" | bc`
	echo "coverage: ${correct} out of ${total} = ${result}" >> ${coverage}
	cat ${coverage}
done
