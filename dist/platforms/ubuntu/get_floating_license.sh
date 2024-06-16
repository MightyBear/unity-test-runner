#!/usr/bin/env bash

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
