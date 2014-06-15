#! /usr/bin/env python

import sys
import argparse
import urllib

gf_files='''api/CombinatorsEst.gf
api/ConstructorsEst.gf
api/SymbolicEst.gf
api/SyntaxEst.gf
api/TryEst.gf
estonian/AdjectiveEst.gf
estonian/AdverbEst.gf
estonian/AllEstAbs.gf
estonian/AllEst.gf
estonian/CatEst.gf
estonian/ConjunctionEst.gf
estonian/DictEstAbs.gf
estonian/DictEst.gf
estonian/ExtraEstAbs.gf
estonian/ExtraEst.gf
estonian/GrammarEst.gf
estonian/HjkEst.gf
estonian/IdiomEst.gf
estonian/IrregEst.gf
estonian/LangEst.gf
estonian/LexiconEst.gf
estonian/MakeStructuralEst.gf
estonian/MorphoEst.gf
estonian/NounEst.gf
estonian/NumeralEst.gf
estonian/ParadigmsEst.gf
estonian/PhraseEst.gf
estonian/QuestionEst.gf
estonian/RelativeEst.gf
estonian/ResEst.gf
estonian/SentenceEst.gf
estonian/StructuralEst.gf
estonian/SymbolEst.gf
estonian/VerbEst.gf'''.split('\n')

default_repo = 'https://raw.githubusercontent.com/GF-Estonian/GF-Estonian/'
default_tag = 'v1.0.0-alpha'

p = argparse.ArgumentParser(description='Downloads GF RG files from the GF-Estonian repository and stores them into subdirectories "api" and "estonian" (which must exist)')
p.add_argument('--repo', type=str, action='store', dest='repo', default=default_repo, help='GF-Estonian repository URL, defaults to: ' + default_repo)
p.add_argument('--tag', type=str, action='store', dest='tag', default=default_tag, help='release tag, defaults to: ' + default_tag)
p.add_argument('-v', '--version', action='version', version='%(prog)s v0.1')

args = p.parse_args()
url_prefix = args.repo + args.tag + '/'

for gf_file in gf_files:
    url = url_prefix + gf_file
    print '{:} > {:}'.format(url, gf_file)
    try:
        urllib.urlretrieve(url, gf_file)
    except IOError as e:
        print "I/O error({0}): {1}: {2}".format(e.errno, e.strerror, gf_file)
        exit()
    except:
        print "Error:", sys.exc_info()[0]
        exit()
