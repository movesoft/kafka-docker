#!/bin/bash

function finish {
    cd /opt/kafka_2.11-0.10.0.1
    echo "stoping zookeeper"
    su kafka -c 'bin/zookeeper-server-stop.sh'
}

trap finish EXIT

KAFKA_HOME=/opt/kafka_2.11-0.10.0.1

# Set the external host and port
if [ -z "$ADVERTISED_HOST" ]; then
    ADVERTISED_HOST=""
fi
if [ -z "$ADVERTISED_PORT" ]; then
    ADVERTISED_PORT=9092
fi

LISTENER="PLAINTEXT://$ADVERTISED_HOST:$ADVERTISED_PORT"
echo "kafka advertised.listeners: $LISTENER"
sed -r -i "s|#(advertised.listeners)=(.*)|\1=$LISTENER|g" $KAFKA_HOME/config/server.properties

cd /opt/kafka_2.11-0.10.0.1
su kafka -c 'bin/zookeeper-server-start.sh -daemon config/zookeeper.properties'
sleep 2
su kafka -c 'bin/kafka-server-start.sh config/server.properties'
