#/bin/bash

# Shows how many of the errors (in the diff-file) are frequent words
#
# Usage:
# cat prev/mkV1.diff.txt | ./freq_err.bash

w=$(mktemp)

./join-freq-diff.bash | grep '[0-9]$' > $w

all=`cat $w | wc -l`
some=`cat $w | grep '#' | wc -l`

result=`echo "scale=4; ${some}/${all}" | bc`
echo "${some} rare words among ${all} errors = ${result}"
