FROM cr.d.xiaomi.net/tangchao5/centos7_base:0.2
MAINTAINER tangchao5@xiaomi.com

RUN mkdir -p /home/work/soft

ADD consul-1.5.0 /home/work/soft/consul-1.5.0
ADD build_consul.sh /home/work/soft/consul-1.5.0/build_consul.sh

ENV PATH $PATH:/usr/local/go/bin
ENV GOPROXY https://goproxy.io

WORKDIR /home/work/soft/consul-1.5.0

CMD ["/usr/bin/bash", "build_consul.sh"]
