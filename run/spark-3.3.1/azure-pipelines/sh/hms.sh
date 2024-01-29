#!/bin/bash -e
if [ "$#" -ne 7 ]; then
    echo "Usage: $0 HMS_JDBC_DRIVER HMS_JDBC_URL HMS_JDBC_USER HMS_JDBC_PASSWORD HMS_STORAGE_ACCOUNT HMS_STORAGE_ACCOUNT_SHARED_KEY HMS_STORAGE_ACCOUNT_CONTAINER"
    exit 1
fi

source env.sh
if [ -z "${SPARK_HOME}" ]; then
    echo "ERROR: SPARK_HOME is not defined."
    exit 1
fi

export HMS_JDBC_DRIVER=$1
export HMS_JDBC_URL=$2
export HMS_JDBC_USER=$3
export HMS_JDBC_PASSWORD=$4
export HMS_STORAGE_ACCOUNT=$5
export HMS_STORAGE_ACCOUNT_SHARED_KEY=$6
export HMS_STORAGE_ACCOUNT_CONTAINER=$7
export HIVE_HOME=/home/$USER/hive

# Install Hive (needed for HMS)
rm -rf apache-hive-2.3.9-bin
wget -nv -N https://downloads.apache.org/hive/hive-2.3.9/apache-hive-2.3.9-bin.tar.gz
tar -xzf apache-hive-2.3.9-bin.tar.gz
ln -sf $(pwd)/apache-hive-2.3.9-bin $HIVE_HOME

# Configure HMS
envsubst < "hive-site.xml.template" > "$HIVE_HOME/conf/hive-site.xml"
ln -sf $HIVE_HOME/conf/hive-site.xml $SPARK_HOME/conf/hive-site.xml

# Copy Azure dependencies to Hive classpath
cp $HADOOP_HOME/share/hadoop/tools/lib/hadoop-azure* $HIVE_HOME/lib/

# Install MSSQL driver
wget -nv -N https://repo1.maven.org/maven2/com/microsoft/sqlserver/mssql-jdbc/6.2.1.jre8/mssql-jdbc-6.2.1.jre8.jar
ln -sf $(pwd)/mssql-jdbc-6.2.1.jre8.jar $SPARK_HOME/jars/mssql-jdbc.jar

# Push to environment
echo "export HIVE_HOME=${HIVE_HOME}" >> env.sh
echo "source $(pwd)/env.sh" >> ~/.bashrc
