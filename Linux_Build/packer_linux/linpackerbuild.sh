#!/bin/bash
#!/bin/bash -eux
# Install Ansible repository and Ansible.
PACKER_JSON=linux.json
PACKER_CREDS=creds/packercreds_ecy3sandpit_lin.sh
LOG_DIR=logs
RAN_NUM=$(date +"%S%M%H%m%d%Y")
LOGFILE=$LOG_DIR/logfile_$RAN_NUM
LINUX_DISTRO=`echo $1 | tr '[:upper:]' '[:lower:]'`
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
    sudo apt-get update;sudo apt-get install ansible -y
elif [[ "$ansible_status" -eq "1" ]] && [[ -f /etc/redhat-release ]] && [[ `grep  -i "release 7" /etc/redhat-release`  ]]; then
    sudo yum install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm -y
    sudo yum install ansible -y
    sleep 5
elif [[ "$ansible_status" -eq "1" ]];then
    echo "Please check for Latest Redhat or Ubuntu OS for running ansible"
    exit 0
fi

which packer > /dev/null
packer_status=$?
if [[ "$packer_status" -eq "1" ]] ; then
    wget -O /tmp/packer_1.0.0_linux_amd64.zip https://releases.hashicorp.com/packer/1.0.0/packer_1.0.0_linux_amd64.zip
    unzip /tmp/packer_1.0.0_linux_amd64.zip
    sudo mv packer /usr/local/bin
    sleep 5
elif [[ "$packer_status" -eq "1" ]];then
    echo "Please check for Latest Redhat or Ubuntu OS for running ansible"
    exit 0
fi
source $PACKER_CREDS


if [[ "$LINUX_DISTRO" == "redhat" ]];then
source creds/redhat.sh
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
elif [[ "$LINUX_DISTRO" == "ubuntu" ]];then
source creds/ubuntu.sh
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
elif [[ "$LINUX_DISTRO" == "centos" ]];then
source creds/centos.sh
echo "OS Version" > $LOGFILE
echo "================================" >> $LOGFILE
echo "IMAGE_PUBLISHER : $IMAGE_PUBLISHER" >> $LOGFILE
echo "IMAGE_OFFER : $IMAGE_OFFER" >> $LOGFILE
echo "IMAGE_SKU : $IMAGE_SKU" >> $LOGFILE
echo "IMAGE_VERSION : $IMAGE_VERSION" >> $LOGFILE
echo "================================" >> $LOGFILE
echo "                     " >> $LOGFILE
echo "                     " >> $LOGFILE
packer
else 
echo "Wrong Input or Linux Distro not supported" | tee $LOGFILE
exit 0
fi
