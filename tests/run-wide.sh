
#cat wide.in.txt | egrep -v "#|\*" | head -100 | pgf-translate ../Translate2.pgf Phr TranslateEng TranslateEst | grep -v "^>" > wide.out.txt

# cat wide.in.txt | egrep -v "(X|Y|Z|'|:|#|\*)" | head -100 | python ../tools/translate.py --pgf ../Translate2.pgf > wide.out.tsv

cat wide.in100.txt | python ../tools/translate.py --pgf ../Translate2.pgf > wide.out.tsv
