FROM centos:7
MAINTAINER simone.leo@crs4.it

ARG HADOOP_VERSION=3.0.3

COPY crs4.hadoop /build/crs4.hadoop/
COPY playbook.yml requirements.yml /build/
COPY entrypoint.sh /

RUN echo "assumeyes=1" >> /etc/yum.conf && \
    yum install epel-release && \
    yum update && \
    yum install python-pip && \
    pip install --no-cache-dir --upgrade pip && \
    pip install 'ansible>=2.4.5,<2.5.0' && \
    ansible-galaxy install -r /build/requirements.yml && \
    ansible-playbook -e "hadoop_version=${HADOOP_VERSION}" /build/playbook.yml && \
    echo "net.ipv6.conf.all.disable_ipv6 = 1" >>/etc/sysctl.conf && \
    echo "net.ipv6.conf.default.disable_ipv6 = 1" >>/etc/sysctl.conf && \
    yum clean all && rm -rf /build && rm -rf /var/cache/yum

# EXPOSE depends on Hadoop version, see the README

ENTRYPOINT ["/entrypoint.sh"]
