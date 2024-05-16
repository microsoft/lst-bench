#!/bin/bash -e
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 SPARK_MASTER_HOST DATA_STORAGE_ACCOUNT DATA_STORAGE_ACCOUNT_SHARED_KEY"
    exit 1
fi

if [ -z "${USER}" ]; then
    echo "ERROR: USER is not defined."
    exit 1
fi

export SPARK_MASTER_HOST=$1
export SPARK_HOME=/home/$USER/spark
export HADOOP_HOME=/home/$USER/hadoop
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
export DATA_STORAGE_ACCOUNT=$2
export DATA_STORAGE_ACCOUNT_SHARED_KEY=$3

# Update dependencies and install packages
sudo apt update -y
sudo apt install -y openjdk-8-jdk wget

# Install Hadoop
rm -rf hadoop-3.3.1
wget -nv -N https://archive.apache.org/dist/hadoop/common/hadoop-3.3.1/hadoop-3.3.1.tar.gz
tar -xzf hadoop-3.3.1.tar.gz
ln -sf $(pwd)/hadoop-3.3.1 $HADOOP_HOME

# Install Spark
rm -rf spark-3.3.1-bin-hadoop3
wget -nv -N https://archive.apache.org/dist/spark/spark-3.3.1/spark-3.3.1-bin-hadoop3.tgz
tar -xf spark-3.3.1-bin-hadoop3.tgz
ln -sf $(pwd)/spark-3.3.1-bin-hadoop3 $SPARK_HOME

# Configure Spark
sudo mkdir -p /opt/spark-events
sudo chown $USER:$USER /opt/spark-events/

cp $SPARK_HOME/conf/spark-env.sh.template $SPARK_HOME/conf/spark-env.sh
cp $SPARK_HOME/conf/spark-defaults.conf.template $SPARK_HOME/conf/spark-defaults.conf

envsubst < "spark-defaults.conf.template" > "$SPARK_HOME/conf/spark-defaults.conf"

envsubst < "spark-env.sh.template" > "$SPARK_HOME/conf/spark-env.sh"

sudo mkdir -p /mnt/local_resource/
sudo mkdir -p /mnt/local_resource/data/
sudo chown $USER:$USER /mnt/local_resource/data
sudo mkdir -p /mnt/local_resource/tmp/
sudo chown $USER:$USER /mnt/local_resource/tmp

# Copy Azure dependencies to Spark classpath
cp $HADOOP_HOME/share/hadoop/tools/lib/hadoop-azure* $SPARK_HOME/jars/

# Push to environment
echo "export HADOOP_HOME=${HADOOP_HOME}
export SPARK_HOME=${SPARK_HOME}
export JAVA_HOME=${JAVA_HOME}
export PATH=${PATH}:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin" >> env.sh
echo "source $(pwd)/env.sh" >> ~/.bashrc
