#!/bin/bash -e
source env.sh
if [ -z "${SPARK_HOME}" ]; then
    echo "ERROR: SPARK_HOME is not defined."
    exit 1
fi

cd $SPARK_HOME

echo "Starting Spark cluster"
./sbin/start-all.sh

echo "Starting history server"
./sbin/start-history-server.sh

echo "Starting thrift server"
if [ "$#" == 0 ]; then
    echo "No LST provided"
    ./sbin/start-thriftserver.sh
elif [ "$1" == "delta" ]; then
    echo "Using delta catalog"
    ./sbin/start-thriftserver.sh --conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog --conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension
elif [ "$1" == "iceberg" ]; then
    echo "Using iceberg catalog"
    ./sbin/start-thriftserver.sh --conf spark.sql.catalog.spark_catalog=org.apache.iceberg.spark.SparkSessionCatalog --conf spark.sql.catalog.spark_catalog.type=hive --conf spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions
elif [ "$1" == "hudi" ]; then
    echo "Using hudi catalog"
    ./sbin/start-thriftserver.sh --conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.hudi.catalog.HoodieCatalog --conf spark.sql.extensions=org.apache.spark.sql.hudi.HoodieSparkSessionExtension
else
    echo "Invalid LST"
    exit 1
fi
