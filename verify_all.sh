#!/bin/bash

# verify all specifications

# exit on error
set -e
# break when pipe fails
set -o pipefail

TIMELIMIT=$1

SPECIFICATIONS=specifications
IMPLEMENTATIONS=implementations
RESULTS=results.csv

echo "specification,realizability_status,num_inputs,num_outputs,controller_latches,controller_and_gates,controller_size,result_verification,time_verification" >$RESULTS

for FILE in $(find $SPECIFICATIONS -mindepth 2 -maxdepth 2 -type f -name "*.tlsf" | sort); do
    echo "Verifying $FILE"

    REALIZABLE=$(basename $(dirname $FILE))
    BASE=$(basename ${FILE%.tlsf})
    NUM_INPUTS=$(syfco --print-input-signals $FILE | sed -e 's/\s*,\s*/ /g' | wc -w)
    NUM_OUTPUTS=$(syfco --print-output-signals $FILE | sed -e 's/\s*,\s*/ /g' | wc -w)

    echo -n "$BASE,$REALIZABLE,$NUM_INPUTS,$NUM_OUTPUTS," >>$RESULTS

    IMPLEMENTATION_FILE=$IMPLEMENTATIONS/$REALIZABLE/$BASE.aag
    if [ -f $IMPLEMENTATION_FILE ]; then
        scripts/print_size.sh $IMPLEMENTATION_FILE >>$RESULTS
        echo -n "," >>$RESULTS

        runtime="$(date +%s%N)"
        scripts/verify.sh $IMPLEMENTATION_FILE $FILE $REALIZABLE $TIMELIMIT >>$RESULTS
        runtime=$(($(date +%s%N)-runtime))
        runtime=$(bc -l <<< "scale=2; $runtime/1000000000")

        echo ",$runtime" >>$RESULTS
    else
        echo "NO_REFERENCE_IMPLEMENTATION" >>$RESULTS
    fi
done
