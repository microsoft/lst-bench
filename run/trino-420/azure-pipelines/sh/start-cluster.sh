#!/bin/bash -e
source env.sh
if [ -z "${HIVE_HOME}" ]; then
    echo "ERROR: HIVE_HOME is not defined."
    exit 1
fi
if [ -z "${TRINO_HOME}" ]; then
    echo "ERROR: TRINO_HOME is not defined."
    exit 1
fi
if [ -z "${HOSTS}" ]; then
    echo "ERROR: HOSTS is not defined."
    exit 1
fi

echo "Starting HMS"
cd $HIVE_HOME
./bin/hive --service metastore &

echo "Starting Trino cluster"
echo "Starting Trino coordinator"
cd $TRINO_HOME
./bin/launcher start
echo "Starting Trino workers"
for node in $HOSTS   ; do ssh -t $node "cd ${TRINO_HOME} && ./bin/launcher start" ; done
