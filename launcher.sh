#!/bin/bash -e

# Constants
LST_BENCH_HOME="$PWD"
LST_BENCH_CLASSPATH="$LST_BENCH_HOME/target/*:$LST_BENCH_HOME/target/lib/*:$LST_BENCH_HOME/target/classes/*"

java -cp $LST_BENCH_CLASSPATH com.microsoft.lst_bench.Driver "$@"
