FROM openjdk:8-jre-alpine3.7

RUN apk --no-cache add bash

# Spark
ENV SPARK_HOME /opt/spark
ENV PATH $PATH:${SPARK_HOME}/bin
ARG SPARK_VERSION=2.3.0
ARG HADOOP_VERSION=2.7
RUN adduser -Ds /bin/bash spark \
    && mkdir -p $SPARK_HOME \
    && apk --no-cache add --virtual .build-dependencies \
    curl \
    tar \
    && export SPARK_PACKAGE=spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} \
    && echo "Downloading and installing Spark version ${SPARK_VERSION} packaged for Hadoop version ${HADOOP_VERSION}." \
    && curl -sL --retry 3 "http://apache.mirror.anlx.net/spark/spark-${SPARK_VERSION}/${SPARK_PACKAGE}.tgz" | \
    tar -xz --strip 1 -C $SPARK_HOME/ \
    && chown -R spark:spark $SPARK_HOME \
    && apk --no-cache del .build-dependencies \
    && rm -rf /var/cache/*

USER spark
WORKDIR $SPARK_HOME
CMD ["bin/spark-class org.apache.spark.deploy.master.Master", "spark"]
