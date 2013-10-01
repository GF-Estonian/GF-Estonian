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

# Verbs
cat $data/abileks_utf8.lx | ./estcglex-to-gf.py --forms $data/abileks.verbs.8forms.csv > out1.txt 2> err1.txt

# Run some diffs
diff out.txt out1.txt
diff err.txt err1.txt

# Now manually: mv out1.txt out.txt

# Convert into GF
cat out.txt | LC_ALL=et_EE.utf8 sort -k1 | uniq | cut -f2 | ./wrap_as_gf_module.py --out=${grammar}
