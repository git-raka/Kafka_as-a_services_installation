# Kafka without confluent and add optional monitoring Kafdrop

### Create directory for kafka and download kafka.tar
```
mkdir kafka && cd kafka && wget https://downloads.apache.org/kafka/3.2.3/kafka_2.12-3.2.3.tgz
```

### Extract kafka.tar.gz
```
tar -xvf kafka_2.12-3.2.3.tgz && cd kafka_2.12-3.2.3 && mv * ../../kafka/ && cd ../../kafka/ && mkdir logs
```
### Edit server.properties of kafka
```
nano ~/kafka/config/server.properties
```

change the logs dir to : 
```
log.dirs=/home/ddi/kafka/logs
```
and append this to EOF
```
delete.topic.enable = true
```

### Create zookerper run as a services 
```
sudo nano /etc/systemd/system/zookeeper.service
```
append this :
https://github.com/git-raka/Kafka_as-a_services_installation/blob/d9faf988b84ef262317b828eb56b76831648ccf1/zookeeper.service#L1-L13



### Create kafka run as a services
```
sudo nano /etc/systemd/system/kafka.service
```
append this :
https://github.com/git-raka/Kafka_as-a_services_installation/blob/d9faf988b84ef262317b828eb56b76831648ccf1/kafka.service#L1-L13

# SETUP KAFKA CONNECT and  Create Kafka connect run as a service
### Set up kafka connect 
```
mkdir /home/kafka/connect
```

### Download plugin connector
this plugin connect is from [conker84](https://github.com/neo4j-contrib/neo4j-streams/releases) thanks to creating this awesome plugin
```
wget https://github.com/neo4j-contrib/neo4j-streams/releases/download/4.1.2/neo4j-kafka-connect-neo4j-2.0.2-kc-oss.zip 
unzip neo4j-kafka-connect-neo4j-2.0.2-kc-oss.zip
```

### Download Debezium Connector
```
cd /home/kafka/connect 
wget https://repo1.maven.org/maven2/io/debezium/debezium-connector-postgres/1.9.6.Final/debezium-connector-postgres-1.9.6.Final-plugin.tar.gz
```

### Set up connect configuration
a properties file you can find in <kafka_home>/config
```
cp connect-distributed.properties connect.properties
```
edit stream.properties file, and append this row to connect directory

```
vi /home/kafka/config/stream.properties
```
and append this row to connect directory
```
plugin.path=/home/raka/kafka/connect
```

```
sudo nano /etc/systemd/system/connect.service
```
append this : 
https://github.com/git-raka/Kafka_as-a_services_installation/blob/d9faf988b84ef262317b828eb56b76831648ccf1/kafka_connect.service#L1-L12



### Start kafka services and kafka connect
```
sudo systemctl start kafka
sudo systemctl status kafka_connect
```
<img width="397" alt="image" src="https://user-images.githubusercontent.com/77326619/193204073-f9ea072e-ce1e-48cc-94a7-ae7d5153b534.png">


### Check status of kafka
```
sudo systemctl status kafka
```
<img width="760" alt="image" src="https://user-images.githubusercontent.com/77326619/193203978-9bbb7b2b-85e5-472b-800d-e1886cd1a32b.png">

# Set up Kafdrop for gui kafka
```
sudo mkdir /opt/kafdrop && cd /opt/kafdrop/ 
curl -LO https://github.com/obsidiandynamics/kafdrop/releases/download/3.30.0/kafdrop-3.30.0.jar
```

### Set kafdrop as a services (OPTIONAL)
```
sudo nano /etc/systemd/system/kafdrop.service
```
and add append this 
```
[Unit]
Description=Kafdrop server
Documentation=https://github.com/obsidiandynamics/kafdrop
Requires=network.target remote-fs.target
After=network.target remote-fs.target

[Service]
Type=simple
ExecStart=/bin/java --add-opens=java.base/sun.nio.ch=ALL-UNNAMED \
    -jar /opt/kafdrop/kafdrop.jar \
    --kafka.brokerConnect=localhost:9092
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
```
### After that start a services
```
sudo systemctl daemon-reload
sudo systemctl start kafdrop
sudo systemctl status kafdrop
sudo systemctl enable kafdrop
```
### Open kafdrop gui
localhost:9000



