#!/usr/bin/env python

# Picks base forms out of the Filosoft morph. synth. (etsyn) output format.
#
# Usage:
#
# cat file.etsyn | ./etsyn-to-forms.py --tag A | sort | uniq
#
# Note that we use sort|uniq to avoid duplicate lines. These can occur
# even if unique lemmas were given to etsyn, e.g. etsyn maps
# both 'vunts' and 'vuntsid' to 'vunts' as the 'sg n' form,
# thus creating a duplicate line.
#
# @author Kaarel Kaljurand
# @version 2013-10-08

import sys
import re
import argparse

forms = {}
prev_line = ""

def show(tag, f):
	"""
	This throws an exception if a form is missing.
	Some words have no analysis (####), i.e. already 'sg n' is missing.
	For some words (e.g. 'ecstasy'), the plural forms are missing.
	In total there are ~400 entries (out of 18k) that fail to get a full analysis.
	"""
	if tag == 'V':
		show_verb(f)
	else:
		show_noun(f)


def show_verb(f):
	print '%s, %s, %s, %s, %s, %s, %s, %s' % (
		'|'.join(f['ma']),
		'|'.join(f['da']),
		'|'.join(f['b']),
		'|'.join(f['takse']),
		'|'.join(f['ge']),
		'|'.join(f['s']),
		'|'.join(f['nud']),
		'|'.join(f['tud'])
		)


def show_noun(f):
	print '%s, %s, %s, %s, %s, %s' % (
		'|'.join(f['sg n']),
		'|'.join(f['sg g']),
		'|'.join(f['sg p']),
		get_ill_adt(f),
		'|'.join(f['pl g']),
		'|'.join(f['pl p'])
		)


def get_ill_adt(f):
	"""
	The adt form is sometimes missing, but if it is present then
	we treat it as equivalent to 'sg ill'.
	"""
	if 'adt' in f:
		return '|'.join(f['sg ill']) + '|' + '|'.join(f['adt'])
	return '|'.join(f['sg ill'])

def add_to_forms(tag, forms, line):
	line = line.strip()
	m = re.match(r"(.+) //_" + tag + "_ (.+), //", line)
	if m:
		key = m.group(2) # morph. category
		val = re.sub(r'\+', '', m.group(1)) # word form
		if key in forms:
			forms[key].append(val)
		else:
			forms[key] = [val]

# Commandline arguments parsing
parser = argparse.ArgumentParser(description='')

parser.add_argument('-t', '--tag', type=str, action='store', dest='tag',
	default="S",
	help='morph. category tag, default: S')

parser.add_argument('-v', '--version', action='version', version='%(prog)s v0.1')

args = parser.parse_args()


for line in sys.stdin:
	if re.match(r'^\s', line):
		add_to_forms(args.tag, forms, line)
	else:
		try:
			show(args.tag, forms)
		except Exception as e:
			print >> sys.stderr, 'Error: {:}: {:}'.format(prev_line, e.message)
		forms = {}
		prev_line = line.rstrip()
