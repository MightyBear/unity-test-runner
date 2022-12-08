#!/usr/bin/env bash

NETWORK_ID="93afae59635206ac"

# Install zerotier
apt-get update
apt install -y software-properties-common
apt-get update
add-apt-repository ppa:git-core/ppa
apt install -y gpg
curl -s 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg' | gpg --import && if z=$(curl -s 'https://install.zerotier.com/' | gpg); then echo "$z" | bash; fi
zerotier-cli status
/usr/sbin/zerotier-one -d

# Join network
zerotier-cli join "$NETWORK_ID"
zerotier-cli info

# Healthcheck on Licensing Server
# curl --connect-timeout 10 'http://10.243.6.149:777/v1/status'
zerotier-cli listnetworks

# Get Floating License
for i in {1..15}

do
	OUTPUT=$(/opt/unity/Editor/Data/Resources/Licensing/Client/Unity.Licensing.Client --acquire-floating)
	echo "Try number $i of 15:"

	if [ $(echo "$OUTPUT" | grep -Ecim1 '(Created|Renewed)') -eq 1 ]; then
		echo $OUTPUT
		echo "Successfully acquired license!"
		break;
	else
		echo $OUTPUT
		echo "Waiting for 60sec before retry..."
		sleep 60;
	fi;
done

/opt/unity/Editor/Data/Resources/Licensing/Client/Unity.Licensing.Client --acquire-floating > license.txt
cat license.txt
PARSEDFILE=$(grep -oP '\".*?\"' < license.txt | tr -d '"')
export FLOATING_LICENSE
FLOATING_LICENSE=$(sed -n 2p <<< "$PARSEDFILE")
FLOATING_LICENSE_TIMEOUT=$(sed -n 4p <<< "$PARSEDFILE")

echo "Acquired floating license: \"$FLOATING_LICENSE\" with timeout $FLOATING_LICENSE_TIMEOUT"
