#!/bin/bash

# Make the full outer join that merges the frequent word list (w1)
# with the coverage test results (w2).
# The result is a table with fields:
# 1. word
# 2. word class (or # if not a frequent word)
# 3. frequency (or # if not a frequent word)
# 4. diff id (or # if correctly analyzed or unanalyzed frequent word)

w1=$(mktemp)
w2=$(mktemp)

# This is important, it makes sort and join have the same idea about order.
# Note that if STDERR contains something like
#     join: /tmp/tmp.5IFbEbt8iI:3697: is not sorted: hoog	3-4-5-6
# then there is a problem.
export LC_ALL=C

# Join wants sorted files
cat ../data/freq.csv | sort -k1 > $w1
cat nouns.6forms.diff.csv | sort -k1 > $w2

# Full outer join
join -a 1 -a 2 -t $'\t' -e'#' -o '0,1.2,1.3,2.2' $w1 $w2
