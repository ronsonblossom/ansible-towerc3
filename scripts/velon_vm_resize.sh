dev_rgname=velondevrg001
prod_rgname=velonprodrg001
test_rgname=velontestrg001

highest_size=Standard_DS3_v2
lowest_size=Standard_DS1_v2

mongodb_dev=^velonmdbd
nifi_dev=^velonnifild

mongodb_prod=^velonmdb
nifi_prod=^velonnifilp

mongodb_test=^velontestld
nifi_test=^velontestlnifi

time_gap=1
mongodb_port=27017
ssh_key=/root/key.pem
ssh_user=vmadmin
NOW=$(date +"%F")
logfile=$0-$NOW.log

status()
{
if [ $? -ne 0 ];then
COMMENTS=$@
sleep 1
echo -e "$COMMENTS"
sleep 1
exit 1
fi
}

mongodb_test()
{
server=$@
#ssh root@"$server"
status "ssh to $server failed"
#nc $server $mongodb_port
status "mongodb service on $server not running"
which mongo
status "please install mongo on your localhost"
cluster_state=`mongo --port $mongodb_port -u "admin" -p "?;PAdNa,J8RFAJx." --authenticationDatabase "admin" --host $server --eval  "rs.status()" | grep -w '"state" : 0' | wc -l`
if [  $cluster_state -eq 0 ];then
echo "mongodb cluster status is good and resize of $server was good and proceeding with next server resize"
else
echo "mongodb cluster status is bad and one of node is bad health hence not proceeding with next server resize or connectivity issue to $server"
exit 1
fi
}


nifi_test()
{
server=$@
#ssh -i $ssh_key $ssh_user@$server
status "ssh to $server failed"
nifi_cluster_state=`ssh -i $ssh_key $ssh_user@$server grep \"ClusterProtocolHeartbeater Heartbeat created\" /opt/nifi/nifi-1.3.0/logs/nifi-app.log > /dev/null`
if [  $? -eq 0 ];then
echo "Nifi cluster status is good and resize of $server was good and proceeding with next server resize"
else
echo "Nifi cluster status is bad and one of node is bad health hence not proceeding with next server resize or connectivity issue to $server"
exit 1
fi
}


reduce_mongodb()
{
for ((i=0; i < ${#hostlist[@]}; i++))
do
rgname=$@
echo az vm resize --resource-group $rgname --name ${hostlist[$i]} --size $lowest_size
status "Resize of ${hostlist[$i]} Failed"
sleep $time_gap
mongodb_test "${hostlist[$i]}"
done
}
increase_mongodb()
{
for ((i=0; i < ${#hostlist[@]}; i++))
do
rgname=$@
echo az vm resize --resource-group $rgname --name ${hostlist[$i]} --size $highest_size 
status "Resize of ${hostlist[$i]} Failed"
sleep $time_gap
mongodb_test "${hostlist[$i]}"
done
}
reduce_nifi()
{
for ((i=0; i < ${#hostlist[@]}; i++))
do
rgname=$@
echo az vm resize --resource-group $rgname --name ${hostlist[$i]} --size $lowest_size 
status "Resize of ${hostlist[$i]} Failed"
sleep $time_gap
nifi_test "${hostlist[$i]}"
done
}
increase_nifi()
{
for ((i=0; i < ${#hostlist[@]}; i++))
do
rgname=$@
echo "az vm resize --resource-group $rgname --name ${hostlist[$i]} --size $highest_size"
status "Resize of ${hostlist[$i]} Failed"
sleep $time_gap
nifi_test "${hostlist[$i]}"
done
}



printf "Please enter which application to be resized ( mongodb or nifi ):"
read app_name
printf "Please enter the environment details ( dev or prod or test):"
read env_name
printf  "Please resize details ( reduce  or increase ):"
read resize_name


app="$app_name"_"$env_name"_"$resize_name"

echo $app
if [ "$env_name" = "dev" ]
then
case "$app" in
   "mongodb_dev_reduce") hostlist=($(az vm list -g $dev_rgname --query "[].name" -o tsv | grep "$mongodb_dev" | xargs)); reduce_mongodb "$dev_rgname"
   ;;
   "nifi_dev_reduce") hostlist=($(az vm list -g $dev_rgname --query "[].name" -o tsv | grep "$nifi_dev" | xargs)); reduce_nifi "$dev_rgname"
   ;;
   "mongodb_dev_increase") hostlist=($(az vm list -g $dev_rgname --query "[].name" -o tsv | grep "$mongodb_dev" | xargs)); increase_mongodb "$dev_rgname"
   ;;
   "nifi_dev_increase") hostlist=($(az vm list -g $dev_rgname --query "[].name" -o tsv | grep "$nifi_dev" | xargs)); increase_nifi "$dev_rgname"
esac
elif [ "$env_name" = "prod" ]
then
case "$app" in
   "mongodb_prod_reduce") hostlist=($(az vm list -g $prod_rgname --query "[].name" -o tsv | grep "$mongodb_prod" | xargs)); reduce_mongodb "$prod_rgname"
   ;;
   "nifi_prod_reduce") hostlist=($(az vm list -g $prod_rgname --query "[].name" -o tsv | grep "$nifi_prod" | xargs)); reduce_nifi "$prod_rgname"
   ;;
   "mongodb_prod_increase") hostlist=($(az vm list -g $prod_rgname --query "[].name" -o tsv | grep "$mongodb_prod" | xargs)); increase_mongodb "$prod_rgname"
   ;;
   "nifi_prod_increase") hostlist=($(az vm list -g $prod_rgname --query "[].name" -o tsv | grep "$nifi_prod" | xargs)); increase_nifi "$prod_rgname"
esac
elif [ "$env_name" = "test" ]
then
case "$app" in
   "mongodb_test_reduce") hostlist=($(az vm list -g $test_rgname --query "[].name" -o tsv | grep "$mongodb_test" | xargs)); reduce_mongodb "$test_rgname"
   ;;
   "nifi_test_reduce") hostlist=($(az vm list -g $test_rgname --query "[].name" -o tsv | grep "$nifi_test" | xargs)); reduce_nifi "$test_rgname"
   ;;
   "mongodb_test_increase") hostlist=($(az vm list -g $test_rgname --query "[].name" -o tsv | grep "$mongodb_test" | xargs)); reduce_mongodb "$test_rgname"
   ;;
   "nifi_test_increase") hostlist=($(az vm list -g $test_rgname --query "[].name" -o tsv | grep "$nifi_test" | xargs)); reduce_nifi "$test_rgname"
esac
else
    printf "environment mentioned is not correct"
fi

