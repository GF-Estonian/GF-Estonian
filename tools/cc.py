#! /usr/bin/env python
#
# Author: Kaarel Kaljurand
# Version: 2013-08-19
#
import sys
import argparse

def quote_form(form):
	return '"' + form + '"'

def quote_form_list(form_list):
	return [quote_form(x) for x in form_list]

def format_gf(cmd, oper, args):
	print '{0} {1} {2}'.format(cmd, oper, ' '.join(quote_form_list(args)))

parser = argparse.ArgumentParser(description='Formats input as GF\'s cc calls')

parser.add_argument('-r', '--resource', type=str, action='store',
	required=True,
	dest='resource',
	help='GF resource module')

parser.add_argument('-c', '--command', type=str, action='store',
	default='cc -list',
	dest='cmd',
	help='GF command (default: cc -list)')

parser.add_argument('--oper', type=str, action='store',
	required=True,
	dest='oper',
	help='GF oper')

parser.add_argument('-v', '--version', action='version', version='%(prog)s v0.1')

args = parser.parse_args()

print 'import -retain {0}'.format(args.resource)
for line in sys.stdin:
	splits = line.strip().split(', ')
	format_gf(args.cmd, args.oper, splits)
