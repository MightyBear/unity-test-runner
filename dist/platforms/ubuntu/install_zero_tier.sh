#!/usr/bin/env bash

NETWORK_ID="93afae59635206ac"

# Install zerotier
apt-get update
curl https://install.zerotier.com | bash
/usr/sbin/zerotier-one -d

# Join Network
for i in {1..5}

do
	OUTPUT=$(zerotier-cli join "$NETWORK_ID")
	echo "Try number $i of 5:"

	if [ $(echo "$OUTPUT" | grep -Ecim1 '200') -eq 1 ]; then
		echo $OUTPUT
		echo "Succesfully connected to zerotier!"
		break;
	else
		echo $OUTPUT
		echo "Waiting for 10sec before retry..."
		sleep 10;
	fi;
done

zerotier-cli status
zerotier-cli info

# Healthcheck on Licensing Server
curl --connect-timeout 10 'http://10.243.6.149:777/v1/status'
zerotier-cli listnetworks

