Tools
=====

Files
-----

For more information see the source code of the files.

### cc

Simplifies GF operator testing from the commandline.

	cat tests/forms_six.csv | python tools/cc.py --oper nForms6 --resource estonian/ResEst.gf | gf --run

### diff-list-set

Compares two files, each of which contains lists of sets.

### estwn-to-etsyn

Extracts nouns, verbs, etc. from the Estonian WordNet tix-file and converts them
into the Filosoft morph. synthesizer input format.

### etsyn-to-6forms

Picks 6 noun forms out of the Filosoft morph. synth. output format.

### etsyn-to-8forms

Picks 8 verb forms out of the Filosoft morph. synth. output format.

### run_hjk_tests

Runs various morph. generation tests saving the results as gold-files into the test-directory.

### test-mk.sh

Runs the morph. generation test for variable number of input arguments,
given a forms-file from the data-directory.
