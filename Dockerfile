FROM centos:7
MAINTAINER simone.leo@crs4.it

RUN yum -y -q install epel-release && \
    yum -y -q install ansible

COPY crs4.hadoop /build/crs4.hadoop/
COPY playbook.yml requirements.yml /build/

RUN ansible-galaxy install -r /build/requirements.yml && \
    ansible-playbook /build/playbook.yml

COPY entrypoint.sh /

EXPOSE 8020 8042 8088 9000 10020 19888 50010 50020 50070 50075 50090

CMD "/entrypoint.sh"
