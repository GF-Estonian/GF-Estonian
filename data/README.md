Various data files
==================

These files have been generated from external resources using external
tools. These files can be used as gold standard in testing, or for
bootstrapping lexical resources for an application grammar.

External tools/resources
------------------------

These tools and resources were used:

  - Filosoft's (<http://www.filosoft.ee/>) morphology tools
  - Estonian WordNet (<http://www.cl.ut.ee/ressursid/teksaurus/>), version kb67a

Files
-----

### nouns.6forms.csv

The 6 forms of nouns. Alternative forms are separated by "|".
This file is useful for regression testing the noun opers.
Do not use it for a lexicon because it does not contain compound words,
and does not specify which of the alternative forms is the default.

Generated with this sequence of steps:

	# Use the WordNet tix-file
	cat kb67a-utf8.tix |

	# Keep only nouns
	estwn-to-etsyn.bash n |

	# Detect the compound structure (but do not guess)
	sed "s/ \/\/.*//" | sed "s/.* //" | etmrf -cio utf8 -P |

	# Keep only simple nouns (incl. the last parts of compounds)
	grep "^ " | grep -v "####" | sed "s/^ *//" | sed "s/.*_//" | sort | uniq |

	# Generate all forms (guess if needed)
	sed 's/$/ \/\/_S_ *, \/\//' | etsyn -cio utf8 -GO |

	# Keep only the 6 forms but exclude hyphenated words
	etsyn-to-6forms.py | grep -v "-" | sort | uniq

where

  - `etmrf` and `etsyn` are Filosoft's tools;
  - `estwn-to-etsyn.bash` and `etsyn-to-6forms.py` are included in the tools-directory;
  - other commands are standard Unix commandline tools.
