# ansible-hadoop
Install and configure Hadoop

```
$ docker build -t crs4/hadoop .
$ docker run --name hadoop -p 8020:8020 -p 8042:8042 -p 8088:8088 -p 9000:9000 -p 10020:10020 -p 19888:19888 -p 50010:50010 -p 50020:50020 -p 50070:50070 -p 50075:50075 -p 50090:50090 -d crs4/hadoop
$ docker exec -it hadoop bash -l

$ jps
162 DataNode
1027 Jps
357 NodeManager
536 JobHistoryServer
76 NameNode
302 ResourceManager
$ hdfs dfs -mkdir -p "/user/${USER}"
$ hdfs dfs -put entrypoint.sh
$ export V=$(hadoop version | head -n 1 | awk '{print $2}')
$ hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-${V}.jar wordcount entrypoint.sh wc_out
[...]
$ hdfs dfs -get wc_out
$ grep hadoop wc_out/part*
```

## Overriding the Configuration

```
$ docker run --rm -it --entrypoint /bin/bash -v /tmp:/tmp crs4/hadoop -c "cp -a /opt/hadoop/etc/hadoop /tmp/hadoop_conf_dir"
$ sed -i 's|^JAVA_HEAP_MAX=.*$|JAVA_HEAP_MAX=-Xmx2000m|g' /tmp/hadoop_conf_dir/yarn-env.sh
$ docker run --name hadoop -p 8020:8020 -p 8042:8042 -p 8088:8088 -p 9000:9000 -p 10020:10020 -p 19888:19888 -p 50010:50010 -p 50020:50020 -p 50070:50070 -p 50075:50075 -p 50090:50090 -v /tmp/hadoop_conf_dir:/opt/hadoop/etc/hadoop -d crs4/hadoop
```

Note that, in `core-site.xml`, `entrypoint.sh` replaces `localhost`
with the container's hostname.
