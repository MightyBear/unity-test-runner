#!/usr/bin/env bash
UNITY_PROJECT_PATH="$GITHUB_WORKSPACE/$PROJECT_PATH"
ORIGINAL_FILE="$UNITY_PROJECT_PATH/services-config.json"
TARGET_DIR="/usr/share/unity3d/config"

# Create config folder
mkdir -p "$TARGET_DIR"

# Move file
if [[ -e "$ORIGINAL_FILE" ]]; then
    mv "$ORIGINAL_FILE" "$TARGET_DIR"
    printf "services-config.json moved to $TARGET_DIR"
else
    printf "services-config.json not found in $UNITY_PROJECT_PATH"
fi