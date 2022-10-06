#!/bin/bash
#
# File: 
# Func: Automatically run LDPC generation
# Revision:
#   - 1.0 (2022-10-06): Initial version
#
# Copyright (C) 2022 Wuqiong Zhao (me@wqhzhao.org)
#
# Help:
#   Arg 1: Check length
#   Arg 2: Code length
#   Arg 3: Random Seed Number (default as 1)
#   Arg 4: Number of adjacent check nodes (default as 1)
#   Arg 5: Additional configuration (for example no4cycle)
# 'evenboth' option is automatically used.

if [ "$#" -lt 2 ]; then
    echo "ERROR: Not enough arguments!"
    exit 1
elif [ "$#" -gt 4 ]; then
    n_rnd="$3"
    n_adj="$4"
    if [ "$#" -gt 5 ]; then
        echo "WARNING: Too many arguments. Ignoring args after the 5th."
    fi
    ./make-ldpc PARITYCHECK.pchk $1 $2 ${n_rnd} evenboth ${n_adj} $5
else
    if [ "$#" -eq 2 ]; then
        n_rnd="1"
        n_adj="3"
    elif [ "$#" -eq 3 ]; then
        n_rnd="$3"
        n_adj="3"
    else # 4 arguments
        n_rnd="$3"
        n_adj="$4"
    fi
    ./make-ldpc PARITYCHECK.pchk $1 $2 ${n_rnd} evenboth ${n_adj}
fi
./make-gen PARITYCHECK.pchk GENERATOR.gen dense
./pchk-to-alist PARITYCHECK.pchk PARITYCHECK.alist dense
if [ "$#" -gt 4 ]; then
    ./print-gen GENERATOR.gen > "LDPC_$1_$2_${n_rnd}_${n_adj}_$5.txt"
else
    ./print-gen GENERATOR.gen > "LDPC_$1_$2_${n_rnd}_${n_adj}.txt"
fi
