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

94 forms:
{Present, Imperfect, Conditional} * {P1, P2, P3} * {Sg, Pl}
Imperative * {P2, P3} * {Sg, Pl} + PlP1 + PlNeg 
Passive * {Present, Past} * {Pos, Neg}
Infinitive * 7 cases
Past participle * {Passive, Active} * 14 cases * {Sg, Pl} + Adv
Present participle 

  - 1-arg paradigm: 90% correct
  - 2-arg paradigm: 96% correct
  - 3-arg paradigm: 98% correct
  - 4-arg paradigm: 99% correct

TODO: do we need all past participle inflected forms?
    
### Lexicon

  - demo lexicon almost translated (TODO: remaining verbs)
  - TODO: derive large lexicon from WordNet

### Syntax

  - some tweaking of the syntax mainly guided by the needs of the MOLTO Phrasebook and ACE-in-GF applications
