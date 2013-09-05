#!/usr/bin/env python

# Compares two files, each of which contains lists of sets.
# Each list is on a separate line, elements separated by ', '.
# Each list element is a set whose elements are separated by '|'.
# For each entry, outputs list identifier (1st element of the list),
# and difference identifier (list of different fields).
#
# Kaarel Kaljurand
# 2013-09-05

import sys
import argparse
import re

def compare(line1, line2):
	"""
	"""
	els1 = line1.strip().split(', ')
	els2 = line2.strip().split(', ')
	if len(els1) != len(els2):
		raise Exception("Lengths not equal: " + len(els1) + " and " + len(els2))
	diff = []
	i = 0
	for el in els1:
		set1 = set(els1[i].split('|'))
		set2 = set(els2[i].split('|'))
		if not are_equal(set1, set2):
			diff.append(str(i + 1))
		i = i + 1
	return (els1[0], '-'.join(diff))


def are_equal(set1, set2):
	"""
	Sets are equal if they have at least one common member.
	TODO: implement also other possible definitions of "equal"
	"""
	return len(set.intersection(set1, set2)) > 0


# Commandline arguments parsing
parser = argparse.ArgumentParser(description='')

parser.add_argument('file1', type=argparse.FileType('r'), help="the 1st file")
parser.add_argument('file2', type=argparse.FileType('r'), help="the 2nd file")
parser.add_argument('-v', '--version', action='version', version='%(prog)s v0.1')

args = parser.parse_args()

for line1 in args.file1:
	try:
		line2 = args.file2.next()
		(tag, result) = compare(line1, line2)
		print '%s\t%s' % (tag, result)
	except Exception as e:
		print >> sys.stderr, 'Error: {:}'.format(e.message)

args.file1.close()
args.file2.close()
