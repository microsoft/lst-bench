#!/bin/bash -e
source env.sh
if [ -z "${SPARK_HOME}" ]; then
    echo "ERROR: SPARK_HOME is not defined."
    exit 1
fi

cd $SPARK_HOME

echo "Stopping thrift server"
./sbin/stop-thriftserver.sh

echo "Stopping history server"
./sbin/stop-history-server.sh

echo "Stopping spark cluster"
./sbin/stop-all.sh