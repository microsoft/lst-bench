#!/bin/bash -e

# Constants
# Directory of the script
export LST_BENCH_HOME="$(dirname "$(readlink -f "$0")")"
LST_BENCH_CLASSPATH="$LST_BENCH_HOME/target/*:$LST_BENCH_HOME/target/lib/*:$LST_BENCH_HOME/target/classes/*"

SPARK_CLASSPATH="${SPARK_HOME}/jars/*"
CLASSPATH="${LST_BENCH_CLASSPATH}:${SPARK_CLASSPATH}"

java -cp ${CLASSPATH} com.microsoft.lst_bench.Driver "$@"
