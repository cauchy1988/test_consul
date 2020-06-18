#!/bin/bash

HOST_IP=`cat /etc/hosts | grep ${HOSTNAME} | awk '{print $1}'`

if [ $IS_AGENT -eq 0 ];then
	if [ $IS_LEADER_HOST -eq 0 ];then
		/home/work/soft/consul agent -server -bind=${HOST_IP} -join=${LEADER_HOST_IP} -node=${HOSTNAME} -data-dir=/home/work/soft/consul.d.server -datacenter=${DATA_CENTER} --node-id=$(uuidgen | awk '{print tolower($0)}') 1>/home/work/soft/consul.stdout.log 2>/home/work/soft/consul.stderr.log
	else
		/home/work/soft/consul agent -server -bind=${HOST_IP} -bootstrap-expect=${BOOT_STRAP_EXPECT} -node=${HOSTNAME} -client=0.0.0.0 -ui -data-dir=/home/work/soft/consul.d.server -datacenter=${DATA_CENTER} --node-id=$(uuidgen | awk '{print tolower($0)}') 1>/home/work/soft/consul.stdout.log 2>/home/work/soft/consul.stderr.log
	fi
else
	/home/work/soft/consul agent -bind=${HOST_IP} -retry-join=${LEADER_HOST_IP} -node=${HOSTNAME} -data-dir=/home/work/soft/consul.d.agent -datacenter=${DATA_CENTER} --node-id=$(uuidgen | awk '{print tolower($0)}') 1>/home/work/soft/consul.stdout.log 2>/home/work/soft/consul.stderr.log
fi
