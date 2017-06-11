#!/bin/bash -eux
# Install Ansible repository and Ansible.
if [ -f /etc/debian_version ]; then
    apt-get update;apt-get install ansible -y
elif [[ -f /etc/redhat-release ]] && [[ `grep  -i "release 7" /etc/redhat-release`  ]]; then
    yum install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm -y
    yum install ansible -y
else
    echo "This is something else"
fi
