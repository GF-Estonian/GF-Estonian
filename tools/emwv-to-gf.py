#!/usr/bin/env python
# -*- coding: utf-8 -*-

# @author Kaarel Kaljurand
# @version 2013-10-04

import sys
import re
import HTMLParser
import htmlentitydefs
import gfutils

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
	fields = line.split(':')
	word = unescape(fields[0]).encode('utf8')
	parts = word.split(' ')
	verb = parts[-1]
	if re.match('^[a-zõäöüšž]+$', verb) and not is_illegal(verb):
		funname = gfutils.get_funname(word, 'V')
		print '%s\t%s = mkV "%s" (mkV %s) ;' % (word, funname, ' '.join(parts[0:-1]), get_forms(verb))
	else:
		print >> sys.stderr, "Warning: line " + str(line_number) + ": ignoring: " + word
