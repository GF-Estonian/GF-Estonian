#!/bin/bash

# Segments the words in the input file where every word is on a separate line.
# The segment border is a space character.
# The segmentation is done using Morfessor (http://www.cis.hut.fi/projects/morpho/, tested with v2.0.1)
# and based on the given model,
# or if missing then on a model learned from the input file.
#
# Usage example:
#
#     bash split-words.bash nouns.txt nouns.model
#
# Kaarel Kaljurand
# 2014-01-14

in=""

if [ $# -lt 1 ]
then
	echo "Usage: split-words.bash <input> [<model>]"
	exit
else
	in=$1
fi

seg="${in}.seg"
rank="${in}.rank"

model=""

# If the 2nd argument is not defined then we build a model
# based on the input file.
# Otherwise we use the given model.
if [ -z "$2" ]
then
	model="${in}.model"
	morfessor -t ${in} -s ${model}
else
	model=$2
fi

morfessor -l ${model} -T ${in} -o ${seg}

# Frequency distribution of the last segment
#cat ${seg} | sed 's/.* //' | sort | uniq -c | sort -nr > ${rank}
