FROM ubuntu
ADD jdk1.8.0_102 /opt/jdk1.8.0_102/
ADD kafka_2.11-0.10.0.1 /opt/kafka_2.11-0.10.0.1/
ADD run_kafka.sh /opt
RUN chmod a+x /opt/run_kafka.sh
RUN useradd -s /bin/bash -m kafka 
RUN chown -R kafka:kafka /opt/kafka_2.11-0.10.0.1
RUN chown -R kafka:kafka /opt/jdk1.8.0_102
RUN apt-get update
RUN apt-get -y install wget
RUN wget https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64.deb
RUN dpkg -i dumb-init_*.deb
ENV JAVA_HOME=/opt/jdk1.8.0_102
ENV PATH=$PATH:/opt/jdk1.8.0_102:/opt/jdk1.8.0_102/bin
VOLUME /tmp
VOLUME /opt/kafka_2.11-0.10.0.1/logs
CMD ["/opt/run_kafka.sh"]
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
EXPOSE 9092 2181
