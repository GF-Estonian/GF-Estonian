#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# For the PGF API see: http://www.grammaticalframework.org/doc/python-api.html
#
# @author Kaarel Kaljurand
# @version 2015-07-23
#
# TODO:
# option: take trees as input

from __future__ import print_function
import sys
import re
import argparse
import pgf
from collections import *

def lowercase_first(s):
    return s[:1].lower() + s[1:] if s else ''

def get_args():
    p = argparse.ArgumentParser(description='')
    p.add_argument('--pgf', type=str, action='store', dest='pgf', required=True)
    p.add_argument('--source', type=str, action='store', dest='source', default='TranslateEng')
    p.add_argument('--target', type=str, action='store', dest='target', default='TranslateEst')
    p.add_argument('-v', '--version', action='version', version='%(prog)s v0.0.1')
    return p.parse_args()

def tokenize(s):
    s1 = lowercase_first(s)
    s2 = re.sub('([.,!?])', r' \1 ', s1)
    return s2


def main():
    args = get_args()
    gr = pgf.readPGF(args.pgf)
    lang_source = gr.languages[args.source]
    lang_target = gr.languages[args.target]
    for line in sys.stdin:
        utt_source = tokenize(line.strip())
        try:
            for prob,tree in lang_source.parse(utt_source):
                utt_target = lang_target.linearize(tree)
                print("{0}\t{1}\t{2}\t{3}".format(utt_source, utt_target, prob, tree))
                # We just print the first result
                break
                #print("Error: parts do not match the input: {0} {1}".format(line, parts), file=sys.stderr)
        except pgf.ParseError as e:
                print("{0}\tPARSE_ERROR".format(utt_source))
        except IndexError as e:
            pass
        except:
            print("Error: " + str(sys.exc_info()[0]), file=sys.stderr)
        finally:
            pass

if __name__ == "__main__":
    main()
