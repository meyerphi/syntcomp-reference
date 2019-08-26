#!/bin/bash

# visualizes an AIG
# uses ABC, DOT and evince

# exit on error
set -e
# break when pipe fails
set -o pipefail

INPUT=$1

echo "Visualizing $INPUT"

# temporary files
BASE_FILE=$(basename ${INPUT%.aag})
AIG_FILE=/tmp/$BASE_FILE.aig
DOT_FILE=/tmp/$BASE_FILE.dot
PDF_FILE=/tmp/$BASE_FILE.pdf

aigtoaig $INPUT $AIG_FILE
echo "read_aiger $AIG_FILE; write_dot $DOT_FILE" | abc >/dev/null
dot -Tpdf -o$PDF_FILE $DOT_FILE

# clean temporary files
rm $AIG_FILE
rm $DOT_FILE

# show pdf file; then clean
evince $PDF_FILE; rm $PDF_FILE
