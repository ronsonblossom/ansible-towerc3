#!/bin/bash -eux
# Install Ansible repository and Ansible.
if [ -f /etc/debian_version ]; then
    apt-get update;apt-get install ansible -y
elif [[ -f /etc/redhat-release ]] && [[ `grep  -i "release 7" /etc/redhat-release`  ]]; then
    wget -P /tmp -nH -r -l1  -A "epel-release-7-*.noarch.rpm" http://dl.fedoraproject.org/pub/epel/7/x86_64/e/
    yum localinstall /tmp/pub/epel/7/x86_64/e/epel-release-7-*.noarch.rpm -y
    yum install ansible -y
else
    echo "This is something else"
fi
