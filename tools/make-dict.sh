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
# It needs to have the files (see also get-resources.bash):
#   - emwv/DB_EMWV_2008.txt (Estonian multi-word units DB)
#     http://www.cl.ut.ee/ressursid/pysiyhendid/DB_EMWV_2008.zip
#   - kb67a/kb67a-utf8.tix (Estonian WordNet)
#     http://www.cl.ut.ee/ressursid/teksaurus/failid/kb67a.zip
#     (latest: http://www.cl.ut.ee/ressursid/teksaurus/viimane/estwn-last.zip)
#   - morfessor/nouns.seg (Morfessor noun segmentation trained on all WordNet nouns)
resources=../resources/

echo "Verbs"
cat $data/abileks_utf8.lx | ./estcglex-to-gf.py --forms $data/abileks.verbs.8forms.csv > out_estcglex.tsv 2> err_estcglex.txt

echo "Multi-word verbs"
cat $resources/emwv/DB_EMWV_2008.txt | ./emwv-to-gf.py -f $data/abileks.verbs.8forms.csv > out_mwv.tsv 2> err_mwv.txt

echo "Adverbs"
cat $resources/kb67a/kb67a-utf8.tix | ./estwn-to-etsyn.bash b | ./adv-to-gf.py > out_adv.tsv

echo "Nouns"
#cat $resources/kb67a/kb67a-utf8.tix | ./estwn-to-etsyn.bash n | ./nouns-to-gf.py --forms $data/nouns.6forms.csv > out_nouns.tsv 2> err_nouns.txt
#cat $resources/segments/nouns.morfessor | ./nouns-to-gf.py --forms $data/nouns.6forms.csv > out_nouns.tsv 2> err_nouns.txt
cat $resources/segments/nouns.vabamorf | ./words-to-gf.py --forms $data/nouns.6forms.csv > out_nouns.tsv 2> err_nouns.txt

echo "Adjectives"
cat $resources/kb67a/kb67a-utf8.tix | ./estwn-to-etsyn.bash a > adj.txt
cat adj.txt | ./adj-to-gf.py --forms $data/adj.6forms.csv > out_adj.tsv 2> err_adj.txt

# Convert into GF
cat out_estcglex.tsv out_mwv.tsv out_adv.tsv out_nouns.tsv out_adj.tsv | LC_ALL=et_EE.utf8 sort -k1 | uniq | cut -f2 | ./wrap_as_gf_module.py --out=${grammar}
