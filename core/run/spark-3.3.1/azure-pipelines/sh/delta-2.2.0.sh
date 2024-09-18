#!/bin/bash -e
source env.sh
if [ -z "${SPARK_HOME}" ]; then
    echo "ERROR: SPARK_HOME is not defined."
    exit 1
fi

wget -nv -N https://repo1.maven.org/maven2/io/delta/delta-core_2.12/2.2.0/delta-core_2.12-2.2.0.jar
wget -nv -N https://repo1.maven.org/maven2/io/delta/delta-storage/2.2.0/delta-storage-2.2.0.jar

ln -sf $(pwd)/delta-core_2.12-2.2.0.jar $SPARK_HOME/jars/delta-core.jar
ln -sf $(pwd)/delta-storage-2.2.0.jar $SPARK_HOME/jars/delta-storage.jar
