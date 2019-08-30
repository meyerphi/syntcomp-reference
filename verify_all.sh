#!/bin/bash

# verify all specifications

# exit on error
set -e
# break when pipe fails
set -o pipefail

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <timelimit>"
    exit 1
fi

TIMELIMIT=$1

SPECIFICATIONS=specifications
IMPLEMENTATIONS=implementations
RESULTS=results.csv

echo "specification,realizability_status,num_inputs,num_outputs,controller_latches,controller_and_gates,controller_size,result_verification,time_verification" >$RESULTS

for SPECIFICATION in $(find $SPECIFICATIONS -mindepth 2 -maxdepth 2 -type f -name "*.tlsf" | sort); do
    BASE=$(basename ${SPECIFICATION%.tlsf})
    REALIZABLE=$(basename $(dirname $SPECIFICATION))

    echo "Verifying $BASE as $REALIZABLE"

    NUM_INPUTS=$(syfco --print-input-signals $SPECIFICATION | sed -e 's/\s*,\s*/ /g' | wc -w)
    NUM_OUTPUTS=$(syfco --print-output-signals $SPECIFICATION | sed -e 's/\s*,\s*/ /g' | wc -w)

    echo -n "$BASE,$REALIZABLE,$NUM_INPUTS,$NUM_OUTPUTS," >>$RESULTS

    IMPLEMENTATION=$IMPLEMENTATIONS/$REALIZABLE/$BASE.aag
    if [ -f $IMPLEMENTATION ]; then
        size=$(scripts/print_size.sh $IMPLEMENTATION)
        echo -n "$size," >>$RESULTS

        runtime="$(date +%s%N)"
        set +e
        result=$(scripts/verify.sh $IMPLEMENTATION $SPECIFICATION $REALIZABLE $TIMELIMIT 2>&1)
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
