Various data files
==================

These files have been generated from external resources using external
tools. These files can be used as gold standard in testing, or for
bootstrapping lexical resources for an application grammar.

External tools/resources
------------------------

These tools and resources were used:

  - Filosoft's (<http://www.filosoft.ee/>) morphology tools
    - etsyn: v1285M
    - etmrf: v1291
  - Estonian WordNet (<http://www.cl.ut.ee/ressursid/teksaurus/>), version kb67a
  - Estonian Constraint Grammar (EstCG) verb lexicon (`abileks_utf8.lx`)

Files
-----

In the code examples:

  - `etmrf` and `etsyn` are Filosoft's tools;
  - the Bash and Python scripts are included in the tools-directory;
  - other commands are standard Unix commandline tools.

### nouns.6forms.csv

The 6 forms of nouns. Alternative forms are separated by "|".
This file is useful for regression testing the noun opers.
Do not use it for a lexicon because it does not contain compound words,
and does not specify which of the alternative forms is the default.

Generated with this sequence of steps:

	# Use the WordNet tix-file
	cat kb67a-utf8.tix |

	# Keep only nouns (exclude entries with spaces and hyphens)
	estwn-to-etsyn.bash n |

	# Detect the compound structure (but do not guess)
	sed "s/ \/\/.*//" | sed "s/.* //" | etmrf -cio utf8 -P |

	# Keep only simple nouns (incl. the last parts of compounds)
	grep "^ " | grep -v "####" | sed "s/^ *//" | sed "s/.*_//" | sort | uniq |

	# Generate all forms (guess if needed)
	sed 's/$/ \/\/_S_ *, \/\//' | etsyn -cio utf8 -GO |

	# Keep only the 6 forms
	etsyn-to-forms.py | sort | uniq


### adj.6forms.csv

The 6 forms of adjectives. Alternative forms are separated by "|".
This file is useful for regression testing the noun opers.
Do not use it for a lexicon because it does not contain compound words,
comparative and superlative forms, and
does not specify which of the alternative forms is the default.

Generated with this sequence of steps:

	# Use the WordNet tix-file
	cat kb67a-utf8.tix |

	# Keep only adjectives (exclude entries with spaces and hyphens)
	estwn-to-etsyn.bash a |

	# Detect the compound structure (but do not guess)
	sed "s/ \/\/.*//" | sed "s/.* //" | etmrf -cio utf8 -P |

	# Keep only simple adjectives (incl. the last parts of compounds)
	grep "^ " | grep -v "####" | sed "s/^ *//" | sed "s/.*_//" | sort | uniq |

	# Generate all forms (guess if needed)
	sed 's/$/ \/\/_A_ *, \/\//' | etsyn -cio utf8 -GO |

	# Keep only the 6 forms
	etsyn-to-forms.py --tag=A | sort | uniq

### verbs.8forms.csv

The 8 forms of verbs. Alternative forms are separated by "|".
This file is useful for regression testing the verb opers.
Do not use it for a lexicon because it does not contain multi-word verbs,
and does not specify which of the alternative forms is the default.

Generated with this sequence of steps:

	# Use the WordNet tix-file
	cat kb67a-utf8.tix |

	# Keep only adjectives (exclude entries with spaces and hyphens)
	estwn-to-etsyn.bash v |

	# Generate all forms (guess if needed)
	etsyn -cio utf8 -GO |

	# Keep only the 8 forms
	etsyn-to-forms.py --tag=V | sort | uniq

### abileks_utf8.lx

Verb lexicon from the Estonian Constraint Grammar parser (EstCG).

Type examples:

	Intr #Ad #El #Kom
	Intransitive with possible case restrictions on adjuncts

	NGP-P #Tr #Kom
	Transitive verb with object in either nom, gen, part.

	Part #In #Kom
	Object must be in partitive

	Part-P #El #In
	Object can be in partitive

	InfP
	???

Frequency of the main tag:

	cat abileks_utf8.lx | grep "V_" | cut -f2 -d' ' | sort | uniq -c | sort -nr | head -5
	3406 >#Intr
	 486 >#NGP-P
	 262 >#Part
	  55 >#Part-P
	  17 >#InfP

### abileks.verbs.8forms.csv

	# Use the verbs from abileks_utf8.lx
	# Some fixes were applied (duplicate removal, z^/s^/zh encoding fixes)
	cat verbs.txt |

	# Generate all the forms
	etsyn -cio utf8 -GO |

	# Keep only the 8 forms
	etsyn-to-forms.py --tag=V | sort | uniq


### freq.csv

	# Download the file
	curl http://www.cl.ut.ee/ressursid/sagedused/tabel1.txt |\
	# Remove DOS newlines
	tr -d "\r" |\
	# Keep only the first 3 columns
	cut -f1,2,3 > /tmp/freq.csv

	# Convert to UTF8
	recode latin1..utf8 /tmp/freq.csv

	# Fix š and ž
	cat /tmp/freq.csv |\
	# Keep lines that have frequency info in them (i.e. exclude the header and the empty lines)
	grep "[0-9]" |\
	sed "s/zh/ž/g" | sed "s/^sh/š/" | sed "s/shsh/šš/" | sed "s/þ/ž/g" | sed "s/ð/š/g" |\
	# Sort
	LC_ALL=et_EE.utf8 sort -k1 > freq.csv
