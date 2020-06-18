#!/bin/bash

docker build -t build_consul:0.1 -f Dockerfile ./
docker run --cidfile cid_file build_consul:0.1

cid=`cat cid_file`
docker cp $cid:/home/work/soft/consul-1.5.0/bin/consul ./

docker rm $cid 

rm -f cid_file
