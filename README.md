# ansible-hadoop
Install and configure Hadoop

```
docker build -t test .
export cid=$(docker run -d -P test)
docker port ${cid}
docker stop ${cid}
```
