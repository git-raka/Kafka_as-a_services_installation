curl -H 'Content-Type: application/json' localhost:8083/connectors --data '
{
  "name": "neo4j",
  "config": {
        "topics": "postgres.public.kirim",
        "connector.class": "streams.kafka.connect.sink.Neo4jSinkConnector",
        "key.converter": "org.apache.kafka.connect.storage.StringConverter",
        "value.converter": "org.apache.kafka.connect.json.JsonConverter",
        "errors.retry.timeout": "-1",
        "errors.retry.delay.max.ms": "1000",
        "errors.tolerance": "all",
        "errors.log.enable": true,
        "errors.log.include.messages": true,
        "neo4j.server.uri": "neo4j://192.168.18.174:7687",
        "neo4j.authentication.basic.username": "neo4j",
        "neo4j.authentication.basic.password": "ddi123",
        "neo4j.batch.parallelize": "false",
        "neo4j.database": "neo4j",
        "neo4j.encryption.enabled": "false",
	"value.converter.schemas.enable":"false",
	"neo4j.topic.cypher.postgres.public.pengiriman": "MERGE (u:Pengiriman {id_pengirim: event.after.id_pengirim}) SET u.nama_pengirim=event.after.nama_pengirim, u.no_hp=event.after.no_hp  "
  }
}'
