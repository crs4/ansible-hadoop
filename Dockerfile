FROM centos:7
MAINTAINER simone.leo@crs4.it

COPY crs4.hadoop /build/crs4.hadoop/
COPY playbook.yml requirements.yml /build/
COPY entrypoint.sh /

RUN echo "assumeyes=1" >> /etc/yum.conf && \
    yum install epel-release && \
    yum update && \
    export ANSIBLE_VERSION=$(yum --showduplicates list ansible | grep ^ansible | awk '{print $2}' | grep '2\.3' | tail -n 1) && \
    yum install "ansible-${ANSIBLE_VERSION}" && \
    ansible-galaxy install -r /build/requirements.yml && \
    ansible-playbook /build/playbook.yml && \
    echo "net.ipv6.conf.all.disable_ipv6 = 1" >>/etc/sysctl.conf && \
    echo "net.ipv6.conf.default.disable_ipv6 = 1" >>/etc/sysctl.conf && \
    yum clean all && rm -rf /build && rm -rf /var/cache/yum

EXPOSE 8020 8042 8088 9000 10020 19888 50010 50020 50070 50075 50090

ENTRYPOINT ["/entrypoint.sh"]
