#! /usr/bin/env python

# Splits noun compounds using Vabamorf.
# Requires pyvabamorf (https://github.com/brainscauseminds/pyvabamorf)

import sys
import re
from pyvabamorf import PyVabamorf
from pprint import pprint

def is_noun_lemma(x):
    return x['partofspeech'] == 'S' and x['form'] == 'sg n'

def select_splits(a):
    return [ x['lemma_tokens'] for x in filter(is_noun_lemma, a[0]['analysis']) ]

def remove_symbols(a):
    return re.sub(r'[]?=+]', '', a).encode('utf8')

m = PyVabamorf()

for line in sys.stdin:
    line = line.strip()
    try:
        result = m.analyze([line])
        splits = select_splits(result)
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
