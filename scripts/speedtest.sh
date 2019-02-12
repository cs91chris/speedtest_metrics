#!/bin/bash

: ${HOST:="local"}
: ${INTERVAL:="5"}
: ${INFLUXDB_HOST:="localhost"}
: ${INFLUXDB_PORT:="8086"}
: ${DB_NAME:="speedtest"}


ENDPOINT="http://${INFLUXDB_HOST}:${INFLUXDB_PORT}/write?db=${DB_NAME}"


while true ; do
	json=$(speedtest-cli --secure --json 2>/dev/null)

	PING=$(echo "$json" | jq '.ping')
	UPLOAD=$(echo "$json" | jq '.upload')
	DOWNLOAD=$(echo "$json" | jq '.download')
	SENT=$(echo "$json" | jq '.bytes_sent')
	RECV=$(echo "$json" | jq '.bytes_received')

	echo "Ping: $PING ms"
	echo "Sent: $SENT bytes"
	echo "Upload: $UPLOAD bytes/s"
	echo "Received: $RECV bytes"
	echo "Download: $DOWNLOAD bytes/s"
	echo "\n"

	curl -s -X POST "$ENDPOINT" --data-binary "ping,host=$HOST value=$PING"
	curl -s -X POST "$ENDPOINT" --data-binary "upload,host=$HOST value=$UPLOAD"
	curl -s -X POST "$ENDPOINT" --data-binary "download,host=$HOST value=$DOWNLOAD"
	curl -s -X POST "$ENDPOINT" --data-binary "sent,host=$HOST value=$SENT"
	curl -s -X POST "$ENDPOINT" --data-binary "recv,host=$HOST value=$RECV"

	sleep $INTERVAL
done

