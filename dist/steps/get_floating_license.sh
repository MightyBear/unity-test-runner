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
curl --connect-timeout 10 'http://10.243.6.149:777/v1/status'

# Get Floating License
/opt/unity/Editor/Data/Resources/Licensing/Client/Unity.Licensing.Client --acquire-floating > license.txt
PARSEDFILE=$(grep -oP '\".*?\"' < license.txt | tr -d '"')
export FLOATING_LICENSE
FLOATING_LICENSE=$(sed -n 2p <<< "$PARSEDFILE")
FLOATING_LICENSE_TIMEOUT=$(sed -n 4p <<< "$PARSEDFILE")

echo "Acquired floating license: \"$FLOATING_LICENSE\" with timeout $FLOATING_LICENSE_TIMEOUT"
