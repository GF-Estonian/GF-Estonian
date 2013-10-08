#!/bin/bash

# Extracts nouns, verbs, etc. (just words, no senses)
# from the Estonian WordNet tix-file and converts them
# into the Filosoft morph. synthesizer input format.
#
# Usage:
#
# cat kb67a-utf8.tix | estwn-to-etsyn.bash

t1=""

if [ $# -eq 1 ]
then
	t1=$1
else
	echo "Usage: estwn-to-etsyn.sh (n|v|a|b)"
	exit
fi

t2=""

if [ "$t1" == "n" ]; then
	t2="S"
elif [ "$t1" == "v" ]; then
	t2="V"
elif [ "$t1" == "a" ]; then
	t2="A"
elif [ "$t1" == "b" ]; then
	t2="D"
else
	echo "Usage: estwn-to-etsyn.sh (n|v|a|b)"
fi

grep ":${t1}: " |\
sed "s/.*:${t1}: //" |\
sed "s/:.*//" |\
# Exclude entries that contain spaces or hyphens
grep -v "[ -]" |\
sort |\
uniq |\
sed "s/$/ \/\/_${t2}_ *, \/\//"
