#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <API-Firewall version>"
    echo "Example: $0 0.8.0"
    exit 1
fi

APIFIREWALL_VERSION="v$1"

# Array of file URLs to download
urls=(
    "https://github.com/wallarm/api-firewall/releases/download/${APIFIREWALL_VERSION}/api-firewall-amd64-musl.tar.gz"
    "https://github.com/wallarm/api-firewall/releases/download/${APIFIREWALL_VERSION}/api-firewall-arm64-musl.tar.gz"
    "https://github.com/wallarm/api-firewall/releases/download/${APIFIREWALL_VERSION}/api-firewall-386-musl.tar.gz"
)

# Loop through each URL
for url in "${urls[@]}"; do
    # Extract the filename from the URL
    filename=$(basename "$url")

    # Download the file
    echo "Downloading $filename..."
    wget -q "$url" -O "$filename"

    # Check if the download was successful
    if [ $? -eq 0 ]; then
        # Calculate and print the SHA-256 checksum
        echo "Checksum for $filename:"
        shasum -a 256 "$filename"
        echo
        rm $filename
    else
        echo "Failed to download $url"
    fi
done