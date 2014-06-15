#!/usr/bin/env python
# -*- coding: utf-8 -*-

# @author Kaarel Kaljurand
# @version 2013-10-04

import sys
import re
import gfutils

illegal = set([])

def get_forms(word):
	if word in lemma_to_forms:
		return lemma_to_forms[word]
	return '"' + word + '"'

def is_illegal(word):
	return (word in illegal) or not (word in lemma_to_forms)

args = gfutils.get_args()

lemma_to_forms = gfutils.get_lemma_to_forms(args.forms)

line_number = 0
for line in sys.stdin:
	line_number += 1
	line = line.strip()
	word = re.sub(' //.*', '', line)
	word = word.strip()
	if re.match('^[a-zõäöüšž]+$', word) and not is_illegal(word):
		funname = gfutils.get_funname(word, 'A')
		print '%s\t%s = mkA (mkN %s) ;' % (word, funname, get_forms(word))
	else:
		print >> sys.stderr, "Warning: line " + str(line_number) + ": ignoring: " + word
