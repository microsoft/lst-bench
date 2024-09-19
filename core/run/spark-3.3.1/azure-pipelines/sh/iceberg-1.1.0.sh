#!/bin/bash -e
source env.sh
if [ -z "${SPARK_HOME}" ]; then
    echo "ERROR: SPARK_HOME is not defined."
    exit 1
fi

wget -nv -N https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-3.3_2.12/1.1.0/iceberg-spark-runtime-3.3_2.12-1.1.0.jar 

ln -sf $(pwd)/iceberg-spark-runtime-3.3_2.12-1.1.0.jar $SPARK_HOME/jars/iceberg-spark-runtime.jar
