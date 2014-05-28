#!/usr/bin/env python
# -*- coding: utf-8 -*-

# @author Kaarel Kaljurand
# @version 2014-01-13

import sys
import re
import argparse

illegal = set([])

def unicode_to_gfcode(u):
	u1 = u.decode("utf8")
	u2 = u1.encode('ascii', 'xmlcharrefreplace')
	u3 = re.sub(r'[^A-Za-z0-9\']', '_', u2)
	return u3

def get_funname(word):
	return unicode_to_gfcode(word)

def fix_form(form):
	"""
	In the case of parallel forms, we keep just the first.
	TODO: improve this
	"""
	form = form.strip()
	return form.split('|')[0]

def get_lemma_to_forms(filename):
	if filename is None:
		return {}
	lemma_to_forms = {}
	with open(filename) as f:
		for line in f:
			splits = line.split(', ')
			lemma_to_forms[ splits[0] ] = ' '.join(['"' + fix_form(x) + '"' for x in splits])
	return lemma_to_forms

def is_illegal(word):
	return (word in illegal)

def get_args():
	p = argparse.ArgumentParser(description='')
	p.add_argument('-f', '--forms', type=str, action='store', dest='forms', help='forms file')
	p.add_argument('-v', '--version', action='version', version='%(prog)s v0.1')
	return p.parse_args()

args = get_args()

lemma_to_forms = get_lemma_to_forms(args.forms)

# The input line can have the Filosoft tag after the '//' sign (which we ignore).
# The word itself can contain spaces to denote Morfessor segment borders.
line_number = 0
for line in sys.stdin:
	line_number += 1
	line = line.strip()
	word = re.sub(' //.*', '', line)
	word = word.strip()
	parts = word.split(' ')
	word = re.sub(' ', '', word)
	if re.match('^[a-zõäöüšž]+$', word) and not is_illegal(word):
		funname = unicode_to_gfcode(word)
		found_word = False
		for i in range(0, len(parts)):
			lemma = ''.join(parts[i:])
			if lemma in lemma_to_forms:
				if i == 0:
					print '%s\t%s_N = mkN %s ;' % (word, funname, lemma_to_forms[lemma])
				else:
					# The word is a compound word
					prefix = ''.join(parts[:i])
					# We do not accept single character prefixes.
					# TODO: These might make sense, depending on how they are coded (ekiri vs e-kiri)
					# TODO: What about 'apriori'?
					if len(prefix) == 1:
						continue
					print '%s\t%s_N = mkN "%s" (mkN %s) ;' % (word, funname, prefix, lemma_to_forms[lemma])
				found_word = True
				break
		if not found_word:
			# Unreliable oper
			print '%s\t%s_N = mkN "%s" ;' % (word, funname, word)
	else:
		print >> sys.stderr, "Warning: line " + str(line_number) + ": ignoring: " + word
