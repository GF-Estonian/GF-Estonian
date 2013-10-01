#! /usr/bin/env python
# coding: utf8

# Creates two GF files, abstract and concrete, containing the strings
# found in STDIN. It is up to the user to make sure that STDIN contains
# syntactically correct strings in the required order, without duplicates,
# UTF8 encoded, etc.

# @author Kaarel Kaljurand
# @version 2013-10-01
#
# TODO:
#
# * don't use explicit \n

import sys
import re
import os
import argparse
from string import Template

template_header_abstract = Template(
"""-- This file has been automatically compiled from multiple sources.
-- Do not manually edit!
abstract ${name} =
	Cat ** {

fun
""")

template_header_concrete = Template(
"""-- This file has been automatically compiled from multiple sources.
-- Do not manually edit!
concrete ${name_concrete} of ${name_abstract} =
	CatEst ** open ParadigmsEst in {

flags coding=utf8;

-- Some helper opers to optimize the file size
oper

cpartitive = casePrep partitive ;
ctranslative = casePrep translative ;
celative = casePrep elative ;
callative = casePrep allative ;

lin
""")


def get_footer():
	return "}"


def get_args():
	p = argparse.ArgumentParser(description='Converts a newline-separated list of strings (from STDIN) into a GF lexicon as an abstract and its corresponding concrete module')
	p.add_argument('-n', '--name', type=str, action='store', dest='name', default='Dict', help='set the name of the grammar (default: Dict)')
	p.add_argument('-l', '--lang', type=str, action='store', dest='lang', default='Est', help='set the language (default: Est)')
	p.add_argument('-o', '--out', type=str, action='store', dest='out', default='.', help='set the output directory (default: .)')
	p.add_argument('-v', '--version', action='version', version='%(prog)s v0.8')
	return p.parse_args()

args = get_args()

name_abstract = args.name + args.lang + "Abs"
name_concrete = args.name + args.lang

fun_names = []
with open(os.path.join(args.out, name_concrete + ".gf"), 'w') as f:
	f.write(template_header_concrete.substitute(name_concrete = name_concrete, name_abstract = name_abstract))
	for line in sys.stdin:
		f.write(line)
		fun = re.sub('=.*', '', line)
		fun_names.append(fun.strip())
	f.write(get_footer())

with open(os.path.join(args.out, name_abstract + ".gf"), 'w') as f:
	f.write(template_header_abstract.substitute(name = name_abstract))
	for name in fun_names:
		tag = re.sub('.*_', '', name)
		f.write('{:} : {:};\n'.format(name, tag))
	f.write(get_footer())
