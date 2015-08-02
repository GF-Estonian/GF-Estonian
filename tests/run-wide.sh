
# Dependencies:
#   - translate.py from https://github.com/Kaljurand/GF-Utils
#   - test-suite from https://github.com/GF-Estonian/test-suite

tests_in="../../test-suite/translate_eng_est/tests.in.txt"
tests_out="../../test-suite/translate_eng_est/tests.out.tsv"
tests_gold="../../test-suite/translate_eng_est/tests.gold.tsv"

pgf="../Translate2.pgf"

# Run this only if the English parser has changed
#time cat ${tests_in} | translate.py --pgf $pgf --tokenize --source TranslateEng --target TranslateEst > ${tests_out}

# Otherwise run only the linearization
time cat ${tests_gold} | translate.py --pgf $pgf --source TranslateEng --target TranslateEst --type=gold > ${tests_out}
