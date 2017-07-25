#!/bin/bash
LOGFILE=$(cat /tmp/logfile_name_30161107252017)
FILEEXT=`echo $LOGFILE | awk -F"_" '{print $2}'`
IP=`awk -F":" '/IP Address/{ print $3 }' $LOGFILE | sed "s/'//g" | sed  "s/ //g" `
echo [all] > /tmp/hosts_$FILEEXT
echo  ${IP} ansible_port=5986 ansible_connection=winrm ansible_winrm_server_cert_validation=ignore ansible_user=osadmin ansible_password=7u4AjagAfe8rec >>  /tmp/hosts_$FILEEXT
cat -v  /tmp/hosts_$FILEEXT | sed -e "s/\^\[\[0m//" > hosts/hosts_$FILEEXT
cd hosts
unlink hosts_file
ln -s hosts_$FILEEXT hosts_file
cd ..
