#!/bin/bash

# verifies an AIG against a TLSF specification
# uses SyfCo, smvtoaig, ltl2smv, combine-aiger and nuXmv

# exit on error
set -e
# break when pipe fails
set -o pipefail

if [ "$#" -lt 4 ]; then
    echo "Usage: $0 <controller.aag> <specification.tlsf> <realizable/unrealizable> <timelimit>"
    exit 1
fi

INPUT=$1
TLSF_FILE=$2
REALIZABLE=$3
TIMELIMIT=$4

#echo "Verifying $INPUT against $TLSF_FILE"

# temporary files
BASE_FILE=$(basename ${INPUT%.aag})
BASE_TLSF_FILE=$(basename ${TLSF_FILE%.tlsf})
MONITOR_AIGER_FILE=/tmp/$BASE_FILE.monitor.aag
COMBINED_FILE=/tmp/$BASE_FILE.combined.aag
SMV_FILE=/tmp/$BASE_FILE.smv
RESULT_FILE=/tmp/$BASE_FILE.result
TLSF_IN=/tmp/$BASE_TLSF_FILE.monitor.in
TLSF_OUT=/tmp/$BASE_TLSF_FILE.monitor.out
AAG_IN=/tmp/$BASE_FILE.controller.in
AAG_OUT=/tmp/$BASE_FILE.controller.out

# verify if inputs and outputs match
syfco --print-input-signals $TLSF_FILE | sed -e 's/\s*,\s*/\n/g' | sort >$TLSF_IN
syfco --print-output-signals $TLSF_FILE | sed -e 's/\s*,\s*/\n/g' | sort >$TLSF_OUT
# need to set +e because there may be 0 inputs or 0 outputs
set +e
grep '^i[0-9]* ' $INPUT | sed -e 's/^i[0-9]* //' | sort >$AAG_IN
grep '^o[0-9]* ' $INPUT | sed -e 's/^o[0-9]* //' | sort >$AAG_OUT
set -e
if [ "$REALIZABLE" == 'unrealizable' ]; then
    tmp=$TLSF_IN
    TLSF_IN=$TLSF_OUT
    TLSF_OUT=$tmp
fi
if ! diff -q $AAG_IN $TLSF_IN; then
    echo "ERROR: Inputs don't match"
    exit 1
fi
if ! diff -q $AAG_OUT $TLSF_OUT; then
    echo "ERROR: Outputs don't match"
    exit 1
fi

# build a monitor for the formula
syfco -f smv -m fully $TLSF_FILE >$SMV_FILE
if [ "$REALIZABLE" == 'unrealizable' ]; then
    sed -e 's/LTLSPEC \(.*\)$/LTLSPEC !(\1)/' -i $SMV_FILE
fi
smvtoaig -L ltl2smv -a $SMV_FILE >$MONITOR_AIGER_FILE 2>/dev/null
COMBINE_AIGER_OPTIONS=""
if [ "$REALIZABLE" == 'unrealizable' ]; then
    COMBINE_AIGER_OPTIONS="--moore"
fi
combine-aiger $COMBINE_AIGER_OPTIONS $MONITOR_AIGER_FILE $INPUT >$COMBINED_FILE

# model check solution
set +e
echo "read_aiger_model -i ${COMBINED_FILE}; encode_variables; build_boolean_model; check_ltlspec_klive; quit" | timeout -k 10 $TIMELIMIT nuXmv -int >$RESULT_FILE
result=$?
set -e

# alternative (but usually slower and more memory-intensive)
#echo "read_aiger_model -i ${COMBINED_FILE}; go; check_ltlspec; quit" | nuXmv -int

# check result
if [ $result -eq 0 ]; then
    if grep -q 'specification .* is true' $RESULT_FILE; then
        echo -n "SUCCESS"
    elif grep -q "specification.*is false" $RESULT_FILE; then
        echo -n "FAILURE"
    else
        echo -n "UNKNOWN"
    fi
elif [ $result -eq 124 ] || [ result -eq 137 ]; then
    echo -n "TIMEOUT"
else
    echo -n "ERROR"
fi

# clean temporary files
rm $MONITOR_AIGER_FILE
rm $COMBINED_FILE
rm $SMV_FILE
rm $RESULT_FILE
rm $TLSF_IN
rm $TLSF_OUT
rm $AAG_IN
rm $AAG_OUT
