#!/bin/bash

# verifies an AIG against a TLSF specification
# uses SyfCo, smvtoaig, ltl2smv, combine-aiger and nuXmv

# exit on error
set -e
# break when pipe fails
set -o pipefail

if [ "$#" -lt 4 ]; then
    echo "Usage: $0 <implementation.aag> <specification.tlsf> <realizable/unrealizable> <timelimit/0> [output.combined.aag]"
    exit 1
fi

IMPLEMENTATION=$1
SPECIFICATION=$2
REALIZABLE=$3
TIMELIMIT=$4

if [ ! -f $IMPLEMENTATION ]; then
    echo "ERROR: Implementation not found"
    exit 1
fi
if [ ! -f $SPECIFICATION ]; then
    echo "ERROR: Specification not found"
    exit 1
fi

# temporary files
BASE=$(basename ${SPECIFICATION%.tlsf})
TLSF_IN=/tmp/$BASE.monitor.in
TLSF_OUT=/tmp/$BASE.monitor.out
MONITOR_FILE=/tmp/$BASE.monitor.aag
if [ "$#" -lt 5 ]; then
    clean_combined=true
    COMBINED_FILE=/tmp/$BASE.combined.aag
else
    clean_combined=false
    COMBINED_FILE=$5
fi
RESULT_FILE=/tmp/$BASE.result

function clean_exit {
    exit_code=$1

    # clean temporary files
    rm -f $TLSF_IN
    rm -f $TLSF_OUT
    rm -f $MONITOR_FILE
    if [ "$clean_combined" == true ]; then
        rm -f $COMBINED_FILE
    fi
    rm -f $RESULT_FILE

    exit $exit_code
}

# verify if inputs and outputs match
syfco --print-input-signals $SPECIFICATION | sed -e 's/\s*,\s*/\n/g' | sort >$TLSF_IN
syfco --print-output-signals $SPECIFICATION | sed -e 's/\s*,\s*/\n/g' | sort >$TLSF_OUT
if [ "$REALIZABLE" == 'unrealizable' ]; then
    tmp=$TLSF_IN
    TLSF_IN=$TLSF_OUT
    TLSF_OUT=$tmp
fi
if ! diff -q $TLSF_IN <(grep '^i[0-9]* ' $IMPLEMENTATION | sed -e 's/^i[0-9]* //' | sort) >/dev/null; then
    echo "ERROR: Inputs don't match"
    clean_exit 1
fi
if ! diff -q $TLSF_OUT <(grep '^o[0-9]* ' $IMPLEMENTATION | sed -e 's/^o[0-9]* //' | sort) >/dev/null; then
    echo "ERROR: Outputs don't match"
    clean_exit 1
fi

# build a monitor for the formula
if [ "$REALIZABLE" == 'unrealizable' ]; then
    combine_aiger_options="--moore"
    rewrite_rule='s/LTLSPEC \(.*\)$/LTLSPEC !(\1)/'
else
    combine_aiger_options=""
    rewrite_rule='/^/n'
fi
syfco -f smv -m fully $SPECIFICATION | sed -e "$rewrite_rule" | smvtoaig -L ltl2smv -a $SMV_FILE >$MONITOR_FILE 2>/dev/null

# combine monitor with implementation
combine-aiger $combine_aiger_options $MONITOR_FILE $IMPLEMENTATION >$COMBINED_FILE

if [ $TIMELIMIT -le 0 ]; then
    # only output combined file
    echo "COMBINED"
    clean_exit 0
fi

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
        echo "SUCCESS"
        clean_exit 0
    elif grep -q "specification.*is false" $RESULT_FILE; then
        echo "FAILURE"
        clean_exit 2
    else
        echo "ERROR: Unknown model checking result"
        clean_exit 1
    fi
elif [ $result -eq 124 ] || [ $result -eq 137 ]; then
    echo "TIMEOUT"
    clean_exit 3
else
    echo "ERROR: Model checking error"
    clean_exit 1
fi
