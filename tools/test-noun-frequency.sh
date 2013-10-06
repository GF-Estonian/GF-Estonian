#/bin/sh

frequencies=tabel1.txt
incorrect=nouns.incorrect.txt
result=nouns.incorrect.frequencies.txt

#rm $result

for word in $(cat $incorrect)
do
	freq=`grep "^${word}\>" $frequencies | cut -f3`
	
	#easier to sort
	echo "${freq}	${word}" >> $result 
done

