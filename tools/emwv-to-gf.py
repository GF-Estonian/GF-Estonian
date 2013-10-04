#!/usr/bin/env python
# -*- coding: utf-8 -*-

# @author Kaarel Kaljurand
# @version 2013-10-04

import sys
import re
import argparse
import HTMLParser
import htmlentitydefs

illegal = set([])

##
# Removes HTML or XML character references and entities from a text string.
#
# @param text The HTML (or XML) source text.
# @return The plain text, as a Unicode string, if necessary.
def unescape(text):
	def fixup(m):
		text = m.group(0)
		if text[:2] == "&#":
			# character reference
			try:
				if text[:3] == "&#x":
					return unichr(int(text[3:-1], 16))
				else:
					return unichr(int(text[2:-1]))
			except ValueError:
				pass
		else:
			# named entity
			try:
				text = unichr(htmlentitydefs.name2codepoint[text[1:-1]])
			except KeyError:
				pass
		return text # leave as is
	return re.sub("&#?\w+;", fixup, text)


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
	fields = line.split(':')
	word = unescape(fields[0]).encode('utf8')
	parts = word.split(' ')
	verb = parts[-1]
	if re.match('^[a-zõäöüšž]+$', verb) and not is_illegal(verb):
		funname = unicode_to_gfcode(word)
		print '%s\t%s_V = mkV "%s" (mkV %s) ;' % (word, funname, ' '.join(parts[0:-1]), get_forms(verb))
	else:
		print >> sys.stderr, "Warning: line " + str(line_number) + ": ignoring: " + word
