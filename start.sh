#!/bin/bash

rm -f cid_file
rm -rf bin
mkdir bin

echo $1

docker build -t build_consul:0.1 -f Dockerfile ./
docker run --cidfile cid_file build_consul:0.1

cid=`cat cid_file`
docker cp $cid:/home/work/soft/consul-1.5.0/bin/consul ./bin/

docker rm $cid 
rm -f cid_file

docker build -t local_consul:0.1 -f Dockerfile_consul ./

#prepare for start consul server
if [ -f "./leader_cid" ];then
	leader_cid=`cat leader_cid`
	docker stop $leader_cid
	docker rm $leader_cid
fi

if [ -f "./server_cid_1" ];then
	cid1=`cat server_cid_1`
	docker stop $cid1
	docker rm $cid1
fi

if [ -f "./server_cid_2" ];then
	cid2=`cat server_cid_2`
	docker stop $cid2
	docker rm $cid2
fi

rm -f leader_cid
rm -f server_cid_1
rm -f server_cid_2

#start leader
docker run -p 0.0.0.0:8500:8500 --cidfile leader_cid -e IS_AGENT=0 -e IS_LEADER_HOST=1 -e BOOT_STRAP_EXPECT=3 -e DATA_CENTER="dclocal" -d local_consul:0.1
leader_cid=`cat leader_cid`
simple_leader_cid=${leader_cid:0:6}
leader_ip=`docker exec $leader_cid cat /etc/hosts | grep $simple_leader_cid | awk '{print $1}'`

echo "leader_cid:${leader_cid}, simple_leader_cid:${simple_leader_cid}, leader_ip:${leader_ip}"

#start other 2 consul server
docker run --cidfile server_cid_1 -e IS_AGENT=0 -e IS_LEADER_HOST=0 -e DATA_CENTER="dclocal" -e LEADER_HOST_IP=$leader_ip -d local_consul:0.1
docker run --cidfile server_cid_2 -e IS_AGENT=0 -e IS_LEADER_HOST=0 -e DATA_CENTER="dclocal" -e LEADER_HOST_IP=$leader_ip -d local_consul:0.1
