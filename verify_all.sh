#!/bin/bash

# verify all specifications

# exit on error
set -e
# break when pipe fails
set -o pipefail

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <timelimit>"
    echo "If <timelimit> is 0, then only the combined files will be output for separate model checking."
    exit 1
fi

TIMELIMIT=$1

SPECIFICATIONS=specifications
IMPLEMENTATIONS=implementations
COMBINATIONS=combined
RESULTS=results.csv

echo "specification,realizability_status,num_inputs,num_outputs,implementation_latches,implementation_and_gates,implementation_size,result_verification,time_verification" >$RESULTS

if [ $TIMELIMIT -eq 0 ]; then
    mkdir -p $COMBINATIONS
    action="Combining"
else
    action="Verifying"
fi

for SPECIFICATION in $(find $SPECIFICATIONS -mindepth 2 -maxdepth 2 -type f -name "*.tlsf" | sort); do
    BASE=$(basename ${SPECIFICATION%.tlsf})
    REALIZABLE=$(basename $(dirname $SPECIFICATION))

    echo "$action $BASE ($REALIZABLE)"

    NUM_INPUTS=$(syfco --print-input-signals $SPECIFICATION | sed -e 's/\s*,\s*/ /g' | wc -w)
    NUM_OUTPUTS=$(syfco --print-output-signals $SPECIFICATION | sed -e 's/\s*,\s*/ /g' | wc -w)

    echo -n "$BASE,$REALIZABLE,$NUM_INPUTS,$NUM_OUTPUTS," >>$RESULTS

    IMPLEMENTATION=$IMPLEMENTATIONS/$REALIZABLE/$BASE.aag
    if [ -f $IMPLEMENTATION ]; then
        size=$(scripts/print_size.sh $IMPLEMENTATION)
        echo -n "$size," >>$RESULTS

        if [ $TIMELIMIT -eq 0 ]; then
            COMBINED=$COMBINATIONS/$BASE.combined.aag
            VERIFICATION_OPTIONS="0 $COMBINED"
        else
            VERIFICATION_OPTIONS="$TIMELIMIT"
        fi

        runtime="$(date +%s%N)"
        set +e
        result=$(scripts/verify.sh $IMPLEMENTATION $SPECIFICATION $REALIZABLE $VERIFICATION_OPTIONS 2>&1)
        set -e
        runtime=$(($(date +%s%N)-runtime))
        runtime=$(bc -l <<< "scale=2; $runtime/1000000000")

        echo $result
        echo "$result,$runtime" >>$RESULTS
    else
        echo "No implementation"
        echo "-,-,-,NO_IMPLEMENTATION,-" >>$RESULTS
    fi
done
