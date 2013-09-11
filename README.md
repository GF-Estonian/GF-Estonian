Estonian grammar in Grammatical Framework
=========================================

Estonian resource grammar for the Grammatical Framework (GF) Resource Grammar Library (RGL).

__This is work in progress!__

We started out with a fork from the Finnish resource grammar with the general plan to:

  - translate the demo lexicon from Finnish to Estonian
  - implement Estonian smart paradigms to replace the Finnish ones
  - tweak the syntax to be Estonian

Status
------

Current status and immediate future plans.

### Nouns

2 numbers and 14 cases.

2 * 14 forms (excluding parallel forms)

  - 1-arg (sg nom) paradigm: 90% correct
  - 6-arg paradigm: 100% correct (?)
  - no parallel forms
  - TODO: add 2-arg paradigm (nom, gen)

### Adjectives

Constructed in the same way as nouns, but have 3 degree forms.

3 * 2 * 14 forms + 2 (?) * 1 adverb forms

  - 1-arg paradigm: 80% correct
  - comparative guessed: TODO: determine correctness
  - TODO: superlative (not urgent)

### Verbs

  - 1-arg paradigm: 93% correct
  - TODO: 2-arg paradigm

### Lexicon

  - demo lexicon almost translated (TODO: remaining verbs)
  - TODO: derive large lexicon from WordNet

### Syntax

  - some tweaking of the syntax mainly guided by the needs of the MOLTO Phrasebook and ACE-in-GF applications
