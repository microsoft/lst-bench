#!/bin/bash -e

# Constants
# Directory of the script
export LST_BENCH_HOME="$(dirname "$(readlink -f "$0")")"
LST_BENCH_CLASSPATH="$LST_BENCH_HOME/core/target/*:$LST_BENCH_HOME/core/target/lib/*:$LST_BENCH_HOME/core/target/classes/*"

java -cp ${LST_BENCH_CLASSPATH} com.microsoft.lst_bench.Driver "$@"
