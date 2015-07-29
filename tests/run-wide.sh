
#cat wide.in.txt | egrep -v "#|\*" | head -100 | pgf-translate ../Translate2.pgf Phr TranslateEng TranslateEst | grep -v "^>" > wide.out.txt

# cat wide.in.txt | egrep -v "(X|Y|Z|'|:|#|\*)" | head -100 | python ../tools/translate.py --pgf ../Translate2.pgf > wide.out.tsv

# translate.py comes from https://github.com/Kaljurand/GF-Utils

# cat wide.in100.txt | translate.py --pgf ../Translate2.pgf --tokenize --source TranslateEng --target TranslateEst > wide.out.tsv

cat wide.gold.tsv | translate.py --pgf ../Translate2.pgf --source TranslateEng --target TranslateEst --type=gold > wide.out.tsv
