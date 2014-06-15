#!/usr/bin/env python
# -*- coding: utf-8 -*-

# @author Kaarel Kaljurand
# @version 2013-10-01

import sys
import re
import gfutils

for line in sys.stdin:
	line = line.strip()
	word = re.sub(' //.*', '', line)
	word = word.strip()
	funname = gfutils.get_funname(word, 'Adv')
	print '%s\t%s = mkAdv "%s" ;' % (word, funname, word)
