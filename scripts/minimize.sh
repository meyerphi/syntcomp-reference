#!/bin/bash

# minimizes an AIG
# uses aigtoaig and ABC

# exit on error
set -e
# break when pipe fails
set -o pipefail

INPUT=$1

echo "Minimizing $INPUT"

# temporary files
BASE_FILE=$(basename ${INPUT%.aag})
AIG_FILE=/tmp/$BASE_FILE.aig
MIN_AIG_FILE=/tmp/$BASE_FILE.min.aig
OUTPUT=/tmp/$BASE_FILE.min.aag

compress2rs="balance -l; resub -K 6 -l; rewrite -l; resub -K 6 -N 2; refactor -l; resub -K 8 -l; balance -l; resub -K 8 -N 2 -l; rewrite -l; resub -K 10 -l; rewrite -z -l; resub -K 10 -N 2 -l; balance -l; resub -K 12 -l; refactor -z -l; resub -K 12 -N 2 -l; balance -l; rewrite -z -l; balance -l"
drwsat2="strash; drw; balance -l; drw; drf; ifraig -C 20; drw; balance -l; drw; drf"
commands="$compress2rs;$drwsat2"

aigtoaig $INPUT $AIG_FILE
echo -e "read_aiger $AIG_FILE\n$commands\nwrite_aiger -s $MIN_AIG_FILE" | ~/local/abc/abc >/dev/null
aigtoaig $MIN_AIG_FILE $OUTPUT

and_old=$(head -n 1 $INPUT | cut -d' ' -f6);
and_new=$(head -n 1 $OUTPUT | cut -d' ' -f6);

if [ $and_new -lt $and_old ]; then
    echo "Minimized $INPUT from $and_old to $and_new";
    cp $OUTPUT $INPUT
fi

# clean temporary files
rm $AIG_FILE
rm $MIN_AIG_FILE
rm $OUTPUT
