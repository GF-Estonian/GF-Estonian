#! /usr/bin/env python

# Splits noun compounds using Vabamorf.
# Requires pyvabamorf (https://github.com/brainscauseminds/pyvabamorf)

# Adjective POS tags are: A, D, U.
# We consider only A (the positive form).

import sys
import re
import argparse
from pyvabamorf import PyVabamorf
from pprint import pprint


def is_lemma_form(pos, x):
    return x['partofspeech'] == pos and x['form'] == 'sg n'

funs_filter = {
    'S': lambda x : is_lemma_form('S', x),
    'A': lambda x : is_lemma_form('A', x)
}

def select_splits(f, a):
    return [ x['lemma_tokens'] for x in filter(f, a[0]['analysis']) ]

def remove_symbols(a):
    return re.sub(r'[]?=+]', '', a).encode('utf8')

p = argparse.ArgumentParser(description='')
p.add_argument('--pos', type=str, action='store', dest='pos', default='S', help='part of speech, one of ' + str(funs_filter.keys()))
p.add_argument('-v', '--version', action='version', version='%(prog)s v0.1')
args = p.parse_args()

fun_filter = funs_filter[args.pos]

m = PyVabamorf()

for line in sys.stdin:
    line = line.strip()
    try:
        result = m.analyze([line])
        splits = select_splits(fun_filter, result)
        # We take just the first solution
        parts = [remove_symbols(x) for x in splits[0]]
        if ''.join(parts) == line:
            line = ' '.join(parts)
        else:
            print >> sys.stderr, "Error: parts do not match the input: {0} {1}".format(line, parts)
    except IndexError as e:
        print >> sys.stderr, "Error: index: {0}".format(line)
    except UnicodeEncodeError as e:
        print >> sys.stderr, "Error: unicode: {0}".format(line)
    except:
        print >> sys.stderr, "Error:", sys.exc_info()[0]
    finally:
        print line
