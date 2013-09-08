#!/usr/bin/env python
#coding=utf8

# Picks 8 verb forms out of the Filsoft morph. synth. (etsyn) output format.
#
# Usage:
#
# cat file.etsyn | ./etsyn-to-8forms.py | sort | uniq
#
# Note that we use sort|uniq to avoid duplicate lines. These can occur
# even if unique lemmas were given to etsyn, e.g. etsyn maps
# both 'vunts' and 'vuntsid' to 'vunts' as the 'sg n' form,
# thus creating a duplicate line.
#
# @author Kaarel Kaljurand
# @version 2013-09-06

import sys
import re

forms = {}
prev_line = ""

def nospace(line):
	line = line.strip()
	if re.match(r"(.+) (.+)//_V_ (.+), //", line):
		return False
        return True
        
verbs = open("verbs.syn").read().split('\n')
verbs = [line for line in verbs if nospace(line)]
gold = open("verbs.8forms.csv", "w")
        
def show(f):
	"""
	This throws an exception if a form is missing.
	Some words have no analysis (####), i.e. already 'sg n' is missing.
	For some words (e.g. 'ecstasy'), the plural forms are missing.
	In total there are ~400 entries (out of 18k) that fail to get a full analysis.
	"""
	
	#print '%s, %s, %s, %s, %s, %s, %s' % (
	gold.write('%s, %s, %s, %s, %s, %s, %s, %s\n' % (
		'|'.join(f['ma']),
		'|'.join(f['da']),
		'|'.join(f['b']),
		'|'.join(f['takse']),
		'|'.join(f['ge']),
		'|'.join(f['s']),
		'|'.join(f['nud']),
		'|'.join(f['tud'])
		))

def add_to_forms(forms, line):
	line = line.strip()
	m = re.match(r"(.+) //_V_ (.+), //", line)
	if m:
		key = m.group(2) # morph. category
		val = re.sub(r'\+', '', m.group(1)) # word form
		if key in forms:
			forms[key].append(val)
		else:
			forms[key] = [val]

#for line in sys.stdin:
for line in verbs:
	if re.match(r'^\s', line):
		add_to_forms(forms, line)
	else:
		try:
			show(forms)			
		except Exception as e:
			print >> sys.stderr, 'Error: {:}: {:}'.format(prev_line, e.message)
		forms = {}
		prev_line = line.rstrip()
