# Kafka without confluent

### Create directory for kafka and download kafka.tar
```
mkdir kafka && cd kafka && wget https://downloads.apache.org/kafka/3.2.3/kafka_2.12-3.2.3.tgz
```

### Extract kafka.tar
```
tar -xvf kafka_2.12-3.2.3.tgz && cd kafka_2.12-3.2.3 && mv * ../../kafka/ && cd ../../kafka/ && mkdir logs
```
### Edit server.properties of kafka
```
nano ~/kafka/config/server.properties
```
<img width="760" alt="image" src="https://user-images.githubusercontent.com/77326619/193204183-e8babf70-a7c6-41b9-b967-4b6374aec22a.png">


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
append this
```
[Unit]
Requires=network.target remote-fs.target
After=network.target remote-fs.target

[Service]
Type=simple
User=ddi
ExecStart=/home/ddi/kafka/bin/zookeeper-server-start.sh /home/ddi/kafka/config/zookeeper.properties
ExecStop=/home/ddi/kafka/bin/zookeeper-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
```
<img width="599" alt="image" src="https://user-images.githubusercontent.com/77326619/193204258-ac0be9e1-bb6f-4a35-9526-a319a425fa8c.png">



### Create kafka run as a services
```
sudo nano /etc/systemd/system/kafka.service
```
append this 
```
[Unit]
Requires=zookeeper.service
After=zookeeper.service

[Service]
Type=simple
User=ddi
ExecStart=/bin/sh -c '/home/ddi/kafka/bin/kafka-server-start.sh /home/ddi/kafka/config/server.properties > /home/ddi/kafka/logs/kafka.log 2>&1'
ExecStop=/home/ddi/kafka/bin/kafka-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
```
<img width="764" alt="image" src="https://user-images.githubusercontent.com/77326619/193204450-c7f70378-b50d-4569-9849-3b88b16e322e.png">


### Start kafka services
```
sudo systemctl start kafka
```
<img width="397" alt="image" src="https://user-images.githubusercontent.com/77326619/193204073-f9ea072e-ce1e-48cc-94a7-ae7d5153b534.png">


### Check status of kafka
```
sudo systemctl status kafka
```
<img width="760" alt="image" src="https://user-images.githubusercontent.com/77326619/193203978-9bbb7b2b-85e5-472b-800d-e1886cd1a32b.png">







