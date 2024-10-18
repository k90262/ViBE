#!/bin/bash
#set -x

FILEID=$1
FILENAME=$2

# Updated `downloading got Google Drive virus scan warning page rather than data files #3935 `solutino from Ref. https://github.com/tensorflow/datasets/issues/3935#issuecomment-2077199771
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file_url> <destination_path>"
    exit 1
fi

file_url="https://drive.google.com/uc?export=download&id=${FILEID}"
destination_path=${FILENAME}

confirmation_page=$(curl -s -L "$file_url")

file_id=$(echo "$confirmation_page" | grep -oE "name=\"id\" value=\"[^\"]+" | sed 's/name="id" value="//')
file_confirm=$(echo "$confirmation_page" | grep -oE "name=\"confirm\" value=\"[^\"]+" | sed 's/name="confirm" value="//')
file_uuid=$(echo "$confirmation_page" | grep -oE "name=\"uuid\" value=\"[^\"]+" | sed 's/name="uuid" value="//')

download_url="https://drive.usercontent.google.com/download?id=$file_id&export=download&confirm=$file_confirm&uuid=$file_uuid"

curl -L -o "$destination_path" "$download_url"

if [ $? -eq 0 ]; then
    echo "Download completed successfully."
else
    echo "Download failed."
fi