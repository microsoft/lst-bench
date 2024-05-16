#!/bin/bash -e
source env.sh
if [ -z "${HOSTS}" ]; then
    echo "ERROR: HOSTS is not defined."
    exit 1
fi

if [ "$#" -lt 2 ]; then
    echo "Error: Please provide at least two input parameters."
    exit 1
fi
deploy_dir=$1
script_file=$2

for node in $HOSTS   ; do ssh -t $node "mkdir -p ~/$deploy_dir" ; done
for node in $HOSTS   ; do scp *.template $node:~/$deploy_dir ; done
for node in $HOSTS   ; do scp $script_file $node:~/$deploy_dir ; done
for node in $HOSTS   ; do ssh -t $node "cd ~/$deploy_dir && chmod +x ./$script_file && ./$script_file ${@:3}" ; done
