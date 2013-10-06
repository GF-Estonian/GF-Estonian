#!/bin/bash

# Make the full outer join merging the frequent word list
# with the coverage test results.
# The result is a table with fields:
# 1. word
# 2. frequency (or missing if not a frequent word)
# 3. diff id (or missing if correctly analyzed or unanalyzed frequent word)
# Missing fields are marked with '#'.

# TODO: fix matching of non-ascii letters

w1=$(mktemp)
w2=$(mktemp)

# Join wants sorted files
cat ../data/freq.csv | LC_ALL=et_EE.utf8 sort -k1 > $w1
cat nouns.6forms.diff.csv | LC_ALL=et_EE.utf8 sort -k1 > $w2

#LC_ALL=et_EE.utf8 join -a 1 -a 2 -t $'\t' -e'#' -o '0,1.2,1.3,2.2' $w1 $w2
#join --nocheck-order -a 1 -a 2 -t $'\t' -e'#' -o '0,1.2,1.3,2.2' $w1 $w2
join -a 1 -a 2 -t $'\t' -e'#' -o '0,1.2,1.3,2.2' $w1 $w2
