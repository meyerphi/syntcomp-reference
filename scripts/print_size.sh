#!/bin/bash

# prints the size of an AIG

# exit on error
set -e
# break when pipe fails
set -o pipefail

INPUT=$1

#n_inputs=$(head -n 1 $INPUT | cut -d' ' -f3);
latches=$(head -n 1 $INPUT | cut -d' ' -f4);
#n_outputs=$(head -n 1 $INPUT | cut -d' ' -f5);
and_gates=$(head -n 1 $INPUT | cut -d' ' -f6);
size=$(($latches + $and_gates))

echo "$latches,$and_gates,$size"
