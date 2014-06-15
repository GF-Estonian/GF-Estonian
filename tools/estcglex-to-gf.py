#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Converts the EstCG verb lexicon into GF format.
# The output contains two tab-separated columns:
# 1. ma-form of the verb (useful if you want to sort the output)
# 2. GF concrete syntax lin entry
# To obtain a syntactically correct GF lexicon, the 2nd column
# should be wrapped with the GF module header and footer.
#
# @author Kaarel Kaljurand
# @version 2013-10-01

import sys
import re
from itertools import islice
import gfutils

def get_rektion(tag):
	splits = re.split('\s+', tag)
	if len(splits) < 2:
		raise Exception("Bad format: '" + tag + "'")
	if not splits[0] == "_V_":
		raise Exception("Unsupported POS tag: '" + tag + "'")
	return splits[1:]

def fix_word(word):
	"""
	Note that sh->š rewriting is not reliable.
	Make sure that such errors have been fixed in the source.
	TODO: rethink the handling of compounds
	"""
	word = re.sub("s\^", "š", word)
	word = re.sub("z\^", "ž", word)
	word = re.sub("zh", "ž", word)
	word = re.sub("_", "", word)
	return word

def get_forms(word):
	if word in lemma_to_forms:
		return lemma_to_forms[word]
	return '"' + word + '"'

def get_lin(word, rektion):
	forms = get_forms(word)
	vtype = rektion[0]
	if vtype == '>#Intr':
		return 'V', '%s' % (forms)
	# TODO: maybe make 3 entries instead
	if vtype == '>#NGP-P':
		return 'V2', '(mkV %s)' % (forms)
	if vtype == '>#Part':
		return 'V2', '(mkV %s) cpartitive' % (forms)
	# TODO: maybe make 2 entries instead
	if vtype == '>#Part-P':
		return 'V2', '(mkV %s) cpartitive' % (forms)
	if vtype == '>#InfP':
		return 'VV', '(mkV %s)' % (forms)
	raise Exception("Unsupported _V_ format: '" + vtype + "'")

def format_gf_lexicon_entry(word, rektion):
	verbtype,lin = get_lin(word, rektion)
	funname = gfutils.get_funname(word, verbtype)
	print '%s\t%s = mk%s %s ;' % (word, funname, verbtype, lin)

args = gfutils.get_args()

lemma_to_forms = gfutils.get_lemma_to_forms(args.forms)

line_number = 0
while True:
	pair = list(islice(sys.stdin, 2))
	if not pair:
		break
	try:
		line_number += 2
		word,tag = pair
		rektion = get_rektion(tag.strip())
		format_gf_lexicon_entry(fix_word(word.strip()) + "ma", rektion)
	except Exception as e:
		print >> sys.stderr, "Error: line " + str(line_number) + ": " + str(e)
