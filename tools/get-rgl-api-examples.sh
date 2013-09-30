#!/bin/sh

# Screen-scrapes the RGL API examples from the RGL online documentation.
# Almost the same as:
# cat ${GF}/lib/doc/api-examples.txt | grep -v "^[ -]" | sort

curl http://www.grammaticalframework.org/lib/doc/synopsis.html |\
grep "API: <CODE>" | sed "s/.*API: <CODE>//" | sed "s/<\/CODE>.*//" | sort
