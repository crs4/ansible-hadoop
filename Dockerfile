FROM centos:7
MAINTAINER simone.leo@crs4.it

ARG HADOOP_VERSION=3.0.1

COPY crs4.hadoop /build/crs4.hadoop/
COPY playbook.yml requirements.yml /build/
COPY entrypoint.sh /

RUN echo "assumeyes=1" >> /etc/yum.conf && \
    yum install epel-release && \
    yum update && \
    export ANSIBLE_VERSION=$(yum --showduplicates list ansible | grep ^ansible | awk '{print $2}' | grep '2\.4' | grep -v '2\.4\.4' | tail -n 1) && \
    yum install "ansible-${ANSIBLE_VERSION}" && \
    ansible-galaxy install -r /build/requirements.yml && \
    ansible-playbook -e "hadoop_version=${HADOOP_VERSION}" /build/playbook.yml && \
    echo "net.ipv6.conf.all.disable_ipv6 = 1" >>/etc/sysctl.conf && \
    echo "net.ipv6.conf.default.disable_ipv6 = 1" >>/etc/sysctl.conf && \
    yum clean all && rm -rf /build && rm -rf /var/cache/yum

# EXPOSE depends on Hadoop version, see the README

ENTRYPOINT ["/entrypoint.sh"]
