#!/bin/bash

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

function onshutdown {
    /opt/hadoop/sbin/mr-jobhistory-daemon.sh stop historyserver
    /opt/hadoop/sbin/yarn-daemon.sh stop nodemanager
    /opt/hadoop/sbin/yarn-daemon.sh stop resourcemanager
    /opt/hadoop/sbin/hadoop-daemon.sh stop datanode
    /opt/hadoop/sbin/hadoop-daemon.sh stop namenode
}

trap onshutdown SIGTERM
trap onshutdown SIGINT

# allow HDFS access from outside the container
sed -i s/localhost/${HOSTNAME}/ /opt/hadoop/etc/hadoop/core-site.xml

if [ $# -gt 0 ]; then
    [ $1 == "-f" ] && /opt/hadoop/bin/hadoop namenode -format -force
fi
/opt/hadoop/sbin/hadoop-daemon.sh start namenode
/opt/hadoop/sbin/hadoop-daemon.sh start datanode
/opt/hadoop/bin/hdfs dfsadmin -safemode wait
/opt/hadoop/sbin/yarn-daemon.sh start resourcemanager
/opt/hadoop/sbin/yarn-daemon.sh start nodemanager
/opt/hadoop/sbin/mr-jobhistory-daemon.sh start historyserver

tail -f /dev/null

onshutdown
