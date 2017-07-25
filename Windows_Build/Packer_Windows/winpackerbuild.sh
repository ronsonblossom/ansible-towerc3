#!/bin/bash
#!/bin/bash -eux
# Install Ansible repository and Ansible.
PACKER_CREDS=creds/packercreds_ecy3sandpit_win.sh
LOG_DIR=logs
RAN_NUM=$(date +"%S%M%H%m%d%Y")
LOGFILE=$LOG_DIR/logfile_$RAN_NUM
PACKER_VERSION=1.0.3
WINDOWS_VERSION=`echo $1 | tr '[:upper:]' '[:lower:]'`
DISK_TYPE=`echo $2 | tr '[:upper:]' '[:lower:]'`
echo $LOGFILE > /tmp/logfile_name_$RAN_NUM
sed -i s"|/tmp/logfile_name_[0-9]*|/tmp/logfile_name_$RAN_NUM|" ip_script.sh

if [[ "$DISK_TYPE" == "md" ]];then
	PACKER_JSON=windows_manageddisk.json
elif [[ "$DISK_TYPE" == "nd" ]];then
	PACKER_JSON=windows_normaldisk.json
else
	echo "Wrong Input or Disk Type not supported" | tee $LOGFILE
	exit 0
fi


packer()
{
	`which packer` build packer_json/$PACKER_JSON >> $LOGFILE 2>&1 &
	echo "Please check for $LOGFILE for Status of the Build"
	find $LOG_DIR/logfile* -mtime +1 -exec rm {} \; > /dev/null 2>&1 &
	find ansible/main.retry -mtime +1 -exec rm {} \; > /dev/null 2>&1 &
}

which ansible > /dev/null
ansible_status=$?
if [[ "$ansible_status" -eq "1" ]] && [[ -f /etc/debian_version ]]; then
#sudo apt-get update;sudo apt-get install ansible -y
sudo apt-get install python-dev libkrb5-dev python-pip -y
sudo pip install ansible
sudo pip install pywinrm[kerberos]
elif [[ "$ansible_status" -eq "1" ]] && [[ -f /etc/redhat-release ]] && [[ `grep  -i "release 7" /etc/redhat-release`  ]]; then
#sudo yum install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm -y
#sudo yum install ansible -y
sudo yum install gcc krb5-devel krb5-workstation
sudo pip install ansible
sudo pip install pywinrm[kerberos]
sleep 5
elif [[ "$ansible_status" -eq "1" ]];then
echo "Please check for Latest Redhat or Ubuntu OS for running ansible"
exit 0
fi

which packer > /dev/null
packer_status=$?
if [[ "$packer_status" -eq "1" ]] ; then
wget -O /tmp/packer_"$PACKER_VERSION"_linux_amd64.zip https://releases.hashicorp.com/packer/$PACKER_VERSION/packer_"$PACKER_VERSION"_linux_amd64.zip
sudo apt-get install unzip -y
unzip /tmp/packer_"$PACKER_VERSION"_linux_amd64.zip
sleep 4
sudo mv packer /usr/local/bin
sleep 5
mkdir logs
elif [[ "$packer_status" -eq "1" ]];then
echo "Please check for Latest Redhat or Ubuntu OS for running ansible"
exit 0
fi

source $PACKER_CREDS



mkdir -p logs

if [[ "$WINDOWS_VERSION" == "windows2012r2" ]];then
source creds/windows2012r2.sh
echo "OS Version" > $LOGFILE
echo "===============================" >> $LOGFILE
echo "IMAGE_PUBLISHER : $IMAGE_PUBLISHER" >> $LOGFILE
echo "IMAGE_OFFER : $IMAGE_OFFER" >> $LOGFILE
echo "IMAGE_SKU : $IMAGE_SKU" >> $LOGFILE
echo "IMAGE_VERSION : $IMAGE_VERSION" >> $LOGFILE
echo "================================" >> $LOGFILE
echo "                     " >> $LOGFILE
echo "                     " >> $LOGFILE
packer
elif [[ "$WINDOWS_VERSION" == "windows2016" ]];then
source creds/windows2016.sh
echo "OS Version" > $LOGFILE
echo "=================================" >> $LOGFILE
echo "IMAGE_PUBLISHER : $IMAGE_PUBLISHER" >> $LOGFILE
echo "IMAGE_OFFER : $IMAGE_OFFER" >> $LOGFILE
echo "IMAGE_SKU : $IMAGE_SKU" >> $LOGFILE
echo "IMAGE_VERSION : $IMAGE_VERSION" >> $LOGFILE
echo "=================================" >> $LOGFILE
echo "                     " >> $LOGFILE
echo "                     " >> $LOGFILE
packer
else
echo "Wrong Input or Windows Version not supported" | tee $LOGFILE
exit 0
fi
