#!/usr/bin/env python
# -*- coding: utf-8 -*-

# @author Kaarel Kaljurand
# @version 2014-06-15

import re
import argparse

illegal = set([])

def unicode_to_gfcode(u):
    u1 = u.decode("utf8")
    u2 = u1.encode('ascii', 'xmlcharrefreplace')
    u3 = re.sub(r'[^A-Za-z0-9\']', '_', u2)
    return u3

def quote_funname(name):
    """
    Quote funnames which contain characters other than [^_A-Za-z0-9]
    """
    if not re.search(r'[\']', name) and re.search(r'[^_A-Za-z0-9]', name):
        return "'" + name + "'"
    return unicode_to_gfcode(name)

def get_funname(word, pos=None):
    word = re.sub(r' ', '_', word)
    if pos is None:
        return quote_funname(word)
    return quote_funname(word + '_' + pos)

def get_forms(lemma_to_forms, word):
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

def is_illegal(lemma_to_forms, word):
	return (word in illegal) or not (word in lemma_to_forms)

def get_args():
	p = argparse.ArgumentParser(description='')
	p.add_argument('-f', '--forms', type=str, action='store', dest='forms', help='forms file')
	p.add_argument('--pos', type=str, action='store', dest='pos', default='N', help='part of speech')
	p.add_argument('-v', '--version', action='version', version='%(prog)s v0.1')
	return p.parse_args()
