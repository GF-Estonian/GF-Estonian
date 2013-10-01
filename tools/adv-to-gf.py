#!/usr/bin/env python
# -*- coding: utf-8 -*-

# @author Kaarel Kaljurand
# @version 2013-10-01

import sys
import re

def unicode_to_gfcode(u):
	u1 = u.decode("utf8")
	u2 = u1.encode('ascii', 'xmlcharrefreplace')
	u3 = re.sub(r'[^A-Za-z0-9\']', '_', u2)
	return u3

for line in sys.stdin:
	line = line.strip()
	word = re.sub(' //.*', '', line)
	word = word.strip()
	funname = unicode_to_gfcode(word)
	print '%s\t%s_Adv = mkAdv "%s" ;' % (word, funname, word)
