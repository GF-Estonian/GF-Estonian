Estonian resource grammar for the GF RGL
========================================

Estonian resource grammar for the [Resource Grammar Library (RGL)](https://github.com/GrammaticalFramework/gf-rgl) of [Grammatical Framework (GF)](https://www.grammaticalframework.org/).

__Note__: This project is currently not being maintained, and the grammar is being improved directly in the RGL project (see
https://github.com/GrammaticalFramework/gf-rgl/tree/master/src/estonian).

Downloading
-----------

Tagged versions and zip-files with external resources are available at <https://github.com/GF-Estonian/GF-Estonian/releases>

To download only the GF files relevant for the resource grammar, execute:

    mkdir -p api estonian
    curl https://raw.githubusercontent.com/GF-Estonian/GF-Estonian/master/tools/download-gf-estonian.py | python


Building
--------

To build the PGF run:

    make pgf_lang

If the building fails with an error message, then compile `ResEst.gf` first:

    make clean
    gf estonian/ResEst.gf
    make pgf_lang


Testing
-------

Running morphology tests:

    cd tools/
    bash test-mk.bash N ../data/nouns.6forms.csv
    bash test-mk.bash N ../data/adj.6forms.csv
    bash test-mk.bash V ../data/verbs.8forms.csv

Running syntax tests:

    make clean
    cd tests/
    sh run_tests.sh

Status
------

We started out with a fork from the Finnish resource grammar with the general plan to:

  - translate the demo lexicon from Finnish to Estonian (`LexiconEst`)
  - implement Estonian smart paradigms to replace the Finnish ones
  - tweak the syntax to be Estonian

This has been mostly accomplished.

### Nouns

2 numbers and 14 cases.

2 * 14 forms (excluding parallel forms)

  - 1-arg (sg nom): 91% correct
  - 2-arg (sg nom gen): 95% correct
  - 3-arg (sg nom gen part): 97% correct
  - 4-arg (sg nom gen part, pl part): 98% correct
  - 6-arg paradigm: 100% correct
  - no parallel forms

### Adjectives

Constructed in the same way as nouns, but have 3 degree forms.

3 * 2 * 14 forms + 2 (?) * 1 adverb forms

  - 1-arg : 90% correct
  - 2-arg : 93% correct
  - 3-arg : 95% correct
  - 4-arg : 97% correct
  - comparative guessed: TODO: determine correctness
  - TODO: superlative (not urgent)

### Verbs

Forms: 40 in total

  - Present : Person * Number
  - Imperfect : Person * Number
  - Conditional : Person * Number
  - Imperative : P2 Sg, P2 Pl, P3, P1 Pl, NegPl
  - Passive : {Present, Past} * {Pos, Neg}
  - Quotative : Active, Passive
  - Past participle : Active, Passive
  - Present participle: Active, Passive
  - Infinitive : da * 2 cases ; ma * 5 cases

Smart paradigm constructors

  - 1-arg paradigm (ma): 90% correct
  - 2-arg paradigm (ma, da): 96% correct
  - 3-arg paradigm (ma, da, b): 98% correct
  - 4-arg paradigm (ma, da, b, takse): 99% correct

### Large lexicon (DictEst)

See: https://github.com/GF-Estonian/lexicons

### Syntax

  - most functions ported to Estonian
  - tested using the MOLTO Phrasebook and ACE-in-GF applications

Papers about GF-Estonian
------------------------

  - Inari Listenmaa and Kaarel Kaljurand. Computational Estonian Grammar in Grammatical Framework. 9th SaLTMiL Workshop on "Free/open-Source Language Resources for the Machine Translation of Less-Resourced Languages", LREC 2014, Reykjavík, Iceland, 27 May 2014. [PDF](http://siuc01.si.ehu.es/~jipsagak/SALTMIL/LREC_2014_Workshop_Proceedings_Saltmil.pdf)

See also the [talks](docs/talks/).

Projects that use GF-Estonian
-----------------------------

  - [Minibar: Resource Demo](http://cloud.grammaticalframework.org/minibar/minibar.html)
  - [Speech grammars](https://github.com/Kaljurand/Grammars)
  - [ACE-in-GF](https://github.com/Attempto/ACE-in-GF)
  - [MOLTO Phrasebook in Estonian](https://github.com/Kaljurand/PhrasebookEst)
