#!/bin/sh

# Compiles the large lexicon from multiple sources.
# TODO: work in progress

# The lexicon must be sorted according to the Estonian locale
# ABCDEFGHIJKLMNOPQRSŠŽTUVWÕÄÖÜXY
#
# Check if you have it:
#   locale -a | grep et_
# If not, then check if it is supported:
#   less /usr/share/i18n/SUPPORTED | grep "et_"
# If yes, then generate it:
#   sudo locale-gen et_EE.UTF-8

data=../data/
grammar=../estonian/
# The resources directory is currently not under version control
resources=../resources/

echo "Verbs"
cat $data/abileks_utf8.lx | ./estcglex-to-gf.py --forms $data/abileks.verbs.8forms.csv > out1.txt 2> err1.txt

echo "Adverbs"
cat $resources/kb67a/kb67a-utf8.tix | ./estwn-to-etsyn.bash b | ./adv-to-gf.py > out_adv.tsv

echo "Nouns"
cat $resources/kb67a/kb67a-utf8.tix | ./estwn-to-etsyn.bash n | ./nouns-to-gf.py --forms $data/nouns.6forms.csv > out_nouns.tsv 2> err_nouns.txt

echo "Adjectives"
cat $resources/kb67a/kb67a-utf8.tix | ./estwn-to-etsyn.bash a | ./adj-to-gf.py --forms $data/adj.6forms.csv > out_adj.tsv 2> err_adj.txt

# Run some diffs
diff out.txt out1.txt
diff err.txt err1.txt

# Now manually: mv out1.txt out.txt

# Convert into GF
cat out.txt out_adv.tsv out_nouns.tsv out_adj.tsv | LC_ALL=et_EE.utf8 sort -k1 | uniq | cut -f2 | ./wrap_as_gf_module.py --out=${grammar}
