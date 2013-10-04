#!/usr/bin/env python
# -*- coding: utf-8 -*-

# @author Kaarel Kaljurand
# @version 2013-10-04

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

def get_forms(word):
	if word in lemma_to_forms:
		return lemma_to_forms[word]
	return '"' + word + '"'

def fix_form(form):
	"""
	In some cases there are parallel forms, we keep just one (randomly)
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
	return (word in illegal) or not (word in lemma_to_forms)

def get_args():
	p = argparse.ArgumentParser(description='')
	p.add_argument('-f', '--forms', type=str, action='store', dest='forms', help='forms file')
	p.add_argument('-v', '--version', action='version', version='%(prog)s v0.1')
	return p.parse_args()

args = get_args()

lemma_to_forms = get_lemma_to_forms(args.forms)

line_number = 0
for line in sys.stdin:
	line_number += 1
	line = line.strip()
	word = re.sub(' //.*', '', line)
	word = word.strip()
	if re.match('^[a-zõäöüšž]+$', word) and not is_illegal(word):
		funname = unicode_to_gfcode(word)
		print '%s\t%s_A = mkA (mkN %s) ;' % (word, funname, get_forms(word))
	else:
		print >> sys.stderr, "Warning: line " + str(line_number) + ": ignoring: " + word
