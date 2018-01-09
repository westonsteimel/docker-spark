FROM openjdk:8-jre-alpine3.7

RUN apk --no-cache add --update curl bash && \
    rm -rf /var/cache/apk/*

# Hadoop
RUN adduser -Ds /bin/bash hadoop
ENV HADOOP_HOME /opt/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$HADOOP_HOME/lib/native
ARG HADOOP_VERSION=3.0.0
RUN mkdir -p $HADOOP_HOME && \
    echo "Downloading and installing Hadoop version ${HADOOP_VERSION}." && \
    curl -sSL --retry 3 "http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" | \
    tar -xz --strip 1 -C $HADOOP_HOME/ && \
    rm -rf $HADOOP_HOME/share/doc && \
    chown -R hadoop:hadoop $HADOOP_HOME

# Spark
RUN adduser -Ds /bin/bash spark
ENV SPARK_HOME /opt/spark
ENV SPARK_DIST_CLASSPATH="$HADOOP_HOME/etc/hadoop/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/tools/lib/*"
ENV PATH $PATH:${SPARK_HOME}/bin
ARG SPARK_VERSION=2.2.1
RUN mkdir -p $SPARK_HOME && \
    export SPARK_PACKAGE=spark-${SPARK_VERSION}-bin-without-hadoop && \
    curl -sL --retry 3 "http://apache.mirror.anlx.net/spark/spark-${SPARK_VERSION}/${SPARK_PACKAGE}.tgz" | \
    tar -xz --strip 1 -C $SPARK_HOME/ && \
    chown -R spark:spark $SPARK_HOME

#Remove unused
RUN apk del curl --no-cache

USER spark
WORKDIR $SPARK_HOME
CMD ["bin/spark-class org.apache.spark.deploy.master.Master", "spark"]
