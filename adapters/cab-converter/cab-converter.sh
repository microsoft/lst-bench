#!/bin/bash -e

# Constants
# Directory of the script
export CAB_CONVERTER_HOME="$(dirname "$(readlink -f "$0")")"
CAB_CONVERTER_CLASSPATH="$CAB_CONVERTER_HOME/target/*:$CAB_CONVERTER_HOME/target/lib/*:$CAB_CONVERTER_HOME/target/classes/*"

java -cp ${CAB_CONVERTER_CLASSPATH} com.microsoft.lst_bench.cab_converter.Driver "$@"
