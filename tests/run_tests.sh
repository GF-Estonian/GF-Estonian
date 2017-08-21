#!/bin/sh

# Simple regression tester:
# 1. Runs some GF scripts and saves their output.
# 2. Compares the output against a previously stored (correct) output.
# 3. If the outputs do not match, then there is either a bug in the grammar
#    or in the previously saved output.
#
# Usage:
#
# sh run_tests.sh
#

mydir=`dirname $0`

api="$mydir/../api/"
path="$mydir/../estonian/"

echo "Testing with exx-resource.gfs..."
# Tests from ${GF}/testsuite/libraries/
gf --preproc=mkPresent --run $path/LangEst.gf < $mydir/exx-resource.gfs > $mydir/exx-resource.gfs.out
diff --brief $mydir/exx-resource.gfs.gold $mydir/exx-resource.gfs.out

echo "Testing with api-examples.gfs..."
# API examples from ${GF}/lib/doc/
# Generated using: make exx-script
gf --path=$path --retain --run $api/TryEst.gf < $mydir/api-examples.gfs > $mydir/api-examples-Est.out
diff --brief $mydir/api-examples-Est.txt $mydir/api-examples-Est.out
# The English examples can be generated and compared like this:
# gf -retain --run alltenses/TryEng.gfo < api-examples.gfs > api-examples-Eng.txt
# vimdiff api-examples-Eng.txt api-examples-Est.txt

# Obsolete
#gf --path $path --run < test_np.gfs > test_out.txt
#gf --path $path --run < test_v.gfs > test_v_out.txt
#gf --run < test_vforms8.gfs > test_v8_out.txt
#gf --run < test_vforms4.gfs > test_v4_out.txt

#echo "Comparing the results..."
#diff test_gold.txt test_out.txt
#diff test_v8_out.txt test_v4_out.txt

echo
echo "View the diffs e.g. using:"
echo "vimdiff $mydir/exx-resource.gfs.gold $mydir/exx-resource.gfs.out"
echo "vimdiff $mydir/api-examples-Est.txt $mydir/api-examples-Est.out"
