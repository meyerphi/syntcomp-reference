#!/bin/bash

# strips an AIG of latch symbols and comments
# uses sed

# exit on error
set -e
# break when pipe fails
set -o pipefail

INPUT=$1

echo "Stripping $INPUT"

sed -n -e '/^l[0-9]/D' -e '/^c/q;p' -i $INPUT
