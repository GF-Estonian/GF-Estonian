# Simple regression tester:
# 1. Runs a GF script and saves the output.
# 2. Compares the output against a previously stored output.
# 3. If the outputs do not match, then there is either a bug in the grammar
#    or in the previously saved output.

# Usage:
#
# sh run_tests.sh
#

path="../estonian/:../abstract/:../common/"

echo "Running the tests..."
gf --path $path --run < test_np.gfs > test_results.txt

echo "Comparing the results..."
diff correct_results.txt test_results.txt
