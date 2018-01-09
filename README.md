# Apache Spark in Docker

[Apache Spark](http://spark.apache.org) running in a Docker container.  Uses [Alpine Linux](https://alpinelinux.org) 
with [OpenJDK](http://openjdk.java.net/) in place of Oracle's official distribution of Java.

## Examples

```
docker run --rm -it -p 4040:4040 westonsteimel/spark bin/run-example SparkPageRank data/mllib/pagerank_data.txt 10
```
