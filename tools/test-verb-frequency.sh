#/bin/sh

wget http://www.cl.ut.ee/ressursid/sagedused/tabel1.txt

frequencies=tabel1.txt
incorrect=verbs.incorrect.txt
result=verbs.incorrect.frequencies.txt

rm $result

for word in $(cat $incorrect)
do
	freq=`grep "^${word}\>" $frequencies | cut -f3`
	
	#easier to sort
	echo "${freq}	${word}" >> $result 
done

