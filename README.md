Estonian resource grammar for the GF RGL
========================================

Estonian resource grammar for the Grammatical Framework (GF) Resource Grammar Library (RGL).

__This is work in progress!__

Status
------

We started out with a fork from the Finnish resource grammar with the general plan to:

  - translate the demo lexicon from Finnish to Estonian
  - implement Estonian smart paradigms to replace the Finnish ones
  - tweak the syntax to be Estonian

This has been mostly accomplished.

### Nouns

2 numbers and 14 cases.

2 * 14 forms (excluding parallel forms)

  - 1-arg (sg nom) paradigm: 90% correct
  - 2-arg (sg nom gen): 91% correct
  - 3-arg (sg nom gen part): 96% correct
  - 4-arg (sg nom gen part, pl part): 97% correct
  - 6-arg paradigm: 100% correct (?)
  - no parallel forms

### Adjectives

Constructed in the same way as nouns, but have 3 degree forms.

3 * 2 * 14 forms + 2 (?) * 1 adverb forms

  - 1-arg paradigm: 90% correct
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
    
### Lexicon

  - demo lexicon (`LexiconEst`)
  - large lexicon (`DictEst`):
    - ~32000 nouns
    - ~10000 multi-word verbs
    - ~4000 single-word verbs
    - ~3500 adverbs
    - ~3000 adjectives
  - TODO: large lexicon with language-independent function names

### Syntax

  - most functions ported to Estonian
  - tested using the MOLTO Phrasebook and ACE-in-GF applications
