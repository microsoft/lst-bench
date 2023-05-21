#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <LST>"
  exit 1
fi

PARAMS=""
if [[ $1 == "delta" ]]; then
  PARAMS="--conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog --conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension"
elif [[ $1 == "hudi" ]]; then
  PARAMS="--conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.hudi.catalog.HoodieCatalog --conf spark.sql.extensions=org.apache.spark.sql.hudi.HoodieSparkSessionExtension"
elif [[ $1 == "iceberg" ]]; then
  PARAMS="--conf spark.sql.catalog.spark_catalog=org.apache.iceberg.spark.SparkSessionCatalog --conf spark.sql.catalog.spark_catalog.type=hive --conf spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions"
else
  echo "Unknown LST: $1"
  exit 1
fi

docker exec -i -u root $SPARK_CONTAINER_ID /bin/bash -c '/bin/bash -s' <<EOF
  /opt/spark/sbin/start-thriftserver.sh $PARAMS
EOF
