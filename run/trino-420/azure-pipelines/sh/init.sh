#!/bin/bash -e
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 IS_COORDINATOR TRINO_MASTER_HOST DATA_STORAGE_ACCOUNT DATA_STORAGE_ACCOUNT_SHARED_KEY"
    exit 1
fi

export HOSTNAME=$(hostname)
export IS_COORDINATOR=$1
export TRINO_MASTER_HOST=$2
export TRINO_HOME=/home/$USER/trino
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export DATA_STORAGE_ACCOUNT=$3
export DATA_STORAGE_ACCOUNT_SHARED_KEY=$4

# Update dependencies and install packages
sudo apt update -y
sudo apt install -y openjdk-17-jdk python wget

# Install Trino
rm -rf trino-server-420
wget -nv -N https://repo1.maven.org/maven2/io/trino/trino-server/420/trino-server-420.tar.gz
tar -xzf trino-server-420.tar.gz
ln -sf $(pwd)/trino-server-420 $TRINO_HOME

# Configure Trino
sudo mkdir -p /mnt/local_resource/
sudo mkdir -p /mnt/local_resource/trino_data/
sudo chown $USER:$USER /mnt/local_resource/trino_data
sudo mkdir -p /mnt/local_resource/trino_tmp/
sudo chown $USER:$USER /mnt/local_resource/trino_tmp

sudo mkdir ${TRINO_HOME}/etc
sudo chown $USER:$USER ${TRINO_HOME}/etc/
envsubst < "node.properties.template" > "$TRINO_HOME/etc/node.properties"
envsubst < "jvm.config.template" > "$TRINO_HOME/etc/jvm.config"
if [ "$IS_COORDINATOR" = true ]; then
    envsubst < "coordinator-config.properties.template" > "$TRINO_HOME/etc/config.properties"
elif [ "$IS_COORDINATOR" = false ]; then
    envsubst < "worker-config.properties.template" > "$TRINO_HOME/etc/config.properties"
else
    echo "IS_COORDINATOR must be either 'true' or 'false'"
    exit 1
fi
envsubst < "log.properties.template" > "$TRINO_HOME/etc/log.properties"

# Configure Trino connectors
sudo mkdir ${TRINO_HOME}/etc/catalog
sudo chown $USER:$USER ${TRINO_HOME}/etc/catalog/
envsubst < "hive.properties.template" > "$TRINO_HOME/etc/catalog/hive.properties"
envsubst < "delta.properties.template" > "$TRINO_HOME/etc/catalog/delta.properties"
envsubst < "iceberg.properties.template" > "$TRINO_HOME/etc/catalog/iceberg.properties"

# Set Linux OS limits required for Trino
echo "trino soft nofile 131072
trino hard nofile 131072" | sudo tee -a /etc/security/limits.conf

# Push to environment
echo "export TRINO_HOME=${TRINO_HOME}
export JAVA_HOME=${JAVA_HOME}
export PATH=${PATH}:${TRINO_HOME}/bin" >> env.sh
echo "source $(pwd)/env.sh" >> ~/.bashrc
