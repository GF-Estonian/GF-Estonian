Tools
=====

Note: some of these scripts are obsolete and some have been migrated to
https://github.com/GF-Estonian/tools

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

### etsyn-to-forms.py

Picks the base forms out of the Filosoft morph. synth. output format.
The 6 noun base forms:

  - `sg n`
  - `sg g`
  - `sg p`
  - `sg ill`
  - `pl g`
  - `pl p`

The 8 verb base forms are:

  - `ma`
  - `da`
  - `b`
  - `takse`
  - `ge`
  - `s`
  - `nud`
  - `tud`

See the usage examples in [data/README](../data/README.md).

### run_hjk_tests

Runs various morph. generation tests saving the results as gold-files into the test-directory.

### test-mk.sh

Runs the morph. generation test for variable number of input arguments,
given a forms-file from the data-directory.

### split-nouns-vabamorf.py

Splits compound nouns using Vabamorf (<https://github.com/Filosoft/vabamorf>).
Requires pyvabamorf (<https://github.com/brainscauseminds/pyvabamorf>).

    $ echo "öökullisilm" | ./split-nouns-vabamorf.py
    öö kulli silm

The output is in the form assumed by [make-dict.sh](make-dict.sh).
