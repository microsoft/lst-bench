#!/bin/bash -e
if [ -z "${HOME}" ]; then
    echo "ERROR: HOME is not defined."
    exit 1
fi

# Install packages
sudo apt install -y net-tools nmap

# Configure hosts
my_ip=$(/sbin/ifconfig eth0 | sed -n 's/ *inet [^0-9]*\([0-9\.]\+\).*/\1/p')
ip_range=${my_ip%.*}.*
nmap -sn $ip_range | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | grep -v "^$my_ip$" > $HOME/hostiplist

export HOSTS=$(<$HOME/hostiplist)

for node in $HOSTS   ; do scp ~/.ssh/id_rsa* $node:~/.ssh/ ; done

# Push to environment
echo "export HOSTS=\"${HOSTS}\"" >> env.sh
echo "source $(pwd)/env.sh" >> ~/.bashrc
