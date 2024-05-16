#!/bin/bash -e
source env.sh
if [ -z "${SPARK_HOME}" ]; then
    echo "ERROR: SPARK_HOME is not defined."
    exit 1
fi

rm $SPARK_HOME/jars/delta-core.jar
rm $SPARK_HOME/jars/delta-storage.jar
