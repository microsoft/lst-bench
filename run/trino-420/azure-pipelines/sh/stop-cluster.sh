#!/bin/bash -e
source env.sh
if [ -z "${HOSTS}" ]; then
    echo "ERROR: HOSTS is not defined."
    exit 1
fi
if [ -z "${TRINO_HOME}" ]; then
    echo "ERROR: TRINO_HOME is not defined."
    exit 1
fi

echo "Stopping Trino cluster"
echo "Stopping Trino workers"
for node in $HOSTS   ; do ssh -t $node "cd ${TRINO_HOME} && ./bin/launcher stop" ; done
echo "Stopping Trino coordinator"
cd $TRINO_HOME
./bin/launcher stop

echo "Stopping HMS"
pkill -f "metastore" || true
