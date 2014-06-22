#!/usr/bin/env python
# -*- coding: utf-8 -*-

# @author Kaarel Kaljurand
# @version 2014-06-22

import sys
import re
import gfutils

illegal = set([])

def is_illegal(word):
    return (word in illegal)

args = gfutils.get_args()

lemma_to_forms = gfutils.get_lemma_to_forms(args.forms)

# The input line can have the Filosoft tag after the '//' sign (which we ignore).
# The word itself can contain spaces to denote compound word segment borders.
line_number = 0
for line in sys.stdin:
    line_number += 1
    line = line.strip()
    word = re.sub(' //.*', '', line)
    word = word.strip()
    parts = word.split(' ')
    word = re.sub(' ', '', word)
    if re.match('^[a-zõäöüšž]+$', word) and not is_illegal(word):
        funname = gfutils.get_funname(word, args.pos)
        found_word = False
        entry = ''
        for i in range(0, len(parts)):
            lemma = ''.join(parts[i:])
            if lemma in lemma_to_forms:
                if i == 0:
                    entry = 'mkN %s' % (lemma_to_forms[lemma])
                else:
                    # The word is a compound word
                    prefix = ''.join(parts[:i])
                    # We do not accept single character prefixes.
                    # TODO: These might make sense, depending on how they are coded (ekiri vs e-kiri)
                    # TODO: What about 'apriori'?
                    if len(prefix) == 1:
                        continue
                    entry = 'mkN "%s" (mkN %s)' % (prefix, lemma_to_forms[lemma])
                break
        if entry == '':
            # Unreliable oper
            entry = 'mkN "%s"' % (word)

        if args.pos == 'A':
            print '%s\t%s = mkA (%s) ;' % (word, funname, entry)
        else:
            print '%s\t%s = %s ;' % (word, funname, entry)
    else:
        print >> sys.stderr, "Warning: line " + str(line_number) + ": ignoring: " + word
