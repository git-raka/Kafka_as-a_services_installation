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

### <Optional> Create Kafka connect run as a service
```
sudo nano /etc/systemd/system/kafka_connect.service
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
