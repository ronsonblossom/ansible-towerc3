#!/bin/bash
LOGFILE=$(cat /tmp/logfile_name)
echo $LOGFILE
IP=`awk -F":" '/IP Address/{ print $3 }' $LOGFILE | sed "s/'//g" | sed  "s/ //g" `
echo [all] > /tmp/hosts
echo  ${IP} ansible_port=5986 ansible_connection=winrm ansible_winrm_server_cert_validation=ignore ansible_user=osadmin ansible_password=7u4AjagAfe8rec >>  /tmp/hosts
cat -v  /tmp/hosts | sed -e "s/\^\[\[0m//" > hosts
