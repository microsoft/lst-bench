#!/bin/bash

docker exec -i -u root $SPARK_CONTAINER_ID /bin/bash -c '/bin/bash -s' <<EOF
  apt-get update
  apt-get -y install openssh-server
  /etc/init.d/ssh start
  ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -N ""
  cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys
  echo "export JAVA_HOME=/usr/local/openjdk-11/" >> /opt/spark/sbin/spark-config.sh
  mkdir /opt/spark/conf
  echo "spark.serializer org.apache.spark.serializer.KryoSerializer" >> /opt/spark/conf/spark-defaults.conf
  mkdir /opt/spark/logs
  mkdir /warehouse
  apt-get -y install wget
  # Install Delta Lake
  wget -q https://repo1.maven.org/maven2/io/delta/delta-core_2.12/2.2.0/delta-core_2.12-2.2.0.jar -P /opt/spark/jars/
  wget -q https://repo1.maven.org/maven2/io/delta/delta-storage/2.2.0/delta-storage-2.2.0.jar -P /opt/spark/jars/
  # Install Apache Hudi
  wget -q https://repo1.maven.org/maven2/org/apache/hudi/hudi-spark3.3-bundle_2.12/0.12.2/hudi-spark3.3-bundle_2.12-0.12.2.jar -P /opt/spark/jars/
  # Install Apache Iceberg
  wget -q https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-3.3_2.12/1.1.0/iceberg-spark-runtime-3.3_2.12-1.1.0.jar -P /opt/spark/jars/
  # TPC-DS (TODO: generate data)
  mkdir -p ${external_data_path}call_center
  mkdir -p ${external_data_path}catalog_page
  mkdir -p ${external_data_path}catalog_returns
  mkdir -p ${external_data_path}catalog_sales
  mkdir -p ${external_data_path}customer
  mkdir -p ${external_data_path}customer_address
  mkdir -p ${external_data_path}customer_demographics
  mkdir -p ${external_data_path}date_dim
  mkdir -p ${external_data_path}household_demographics
  mkdir -p ${external_data_path}income_band
  mkdir -p ${external_data_path}inventory
  mkdir -p ${external_data_path}item
  mkdir -p ${external_data_path}promotion
  mkdir -p ${external_data_path}reason
  mkdir -p ${external_data_path}ship_mode
  mkdir -p ${external_data_path}store
  mkdir -p ${external_data_path}store_returns
  mkdir -p ${external_data_path}store_sales
  mkdir -p ${external_data_path}time_dim
  mkdir -p ${external_data_path}warehouse
  mkdir -p ${external_data_path}web_page
  mkdir -p ${external_data_path}web_returns
  mkdir -p ${external_data_path}web_sales
  mkdir -p ${external_data_path}web_site
  for stream_num in {1..20} ; do
    mkdir -p ${external_data_path}${stream_num}/s_catalog_page/
    mkdir -p ${external_data_path}${stream_num}/s_zip_to_gmt/
    mkdir -p ${external_data_path}${stream_num}/s_purchase_lineitem/
    mkdir -p ${external_data_path}${stream_num}/s_customer/
    mkdir -p ${external_data_path}${stream_num}/s_customer_address/
    mkdir -p ${external_data_path}${stream_num}/s_purchase/
    mkdir -p ${external_data_path}${stream_num}/s_catalog_order/
    mkdir -p ${external_data_path}${stream_num}/s_web_order/
    mkdir -p ${external_data_path}${stream_num}/s_item/
    mkdir -p ${external_data_path}${stream_num}/s_catalog_order_lineitem/
    mkdir -p ${external_data_path}${stream_num}/s_web_order_lineitem/
    mkdir -p ${external_data_path}${stream_num}/s_store/
    mkdir -p ${external_data_path}${stream_num}/s_call_center/
    mkdir -p ${external_data_path}${stream_num}/s_web_site/
    mkdir -p ${external_data_path}${stream_num}/s_warehouse/
    mkdir -p ${external_data_path}${stream_num}/s_web_page/
    mkdir -p ${external_data_path}${stream_num}/s_promotion/
    mkdir -p ${external_data_path}${stream_num}/s_store_returns/
    mkdir -p ${external_data_path}${stream_num}/s_catalog_returns/
    mkdir -p ${external_data_path}${stream_num}/s_web_returns/
    mkdir -p ${external_data_path}${stream_num}/s_inventory/
  done
EOF