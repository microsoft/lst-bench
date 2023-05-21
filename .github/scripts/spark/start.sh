#!/bin/bash

docker exec -i -u root $SPARK_CONTAINER_ID /bin/bash -c '/bin/bash -s' <<EOF
  /opt/spark/sbin/start-all.sh
EOF