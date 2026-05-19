##!/bin/bash

## Usage: ./create-containers.sh <number-of-containers> <base-name> <ubuntu-version>
## Example: ./create-containers.sh 3 clickhouse 24.04

CONTAINER_COUNT=${1:-3}
BASE_NAME=${2:-"test-node"}
UBUNTU_VERSION=${3:-"24.04"}

echo "Creating $CONTAINER_COUNT LXC containers..."

for i in $(seq 1 $CONTAINER_COUNT); do
  CONTAINER_NAME="${BASE_NAME}-${i}"
  echo "Creating container: $CONTAINER_NAME"
  lxc launch ubuntu:$UBUNTU_VERSION $CONTAINER_NAME

  if [ $? -eq 0 ]; then
    echo "✅ $CONTAINER_NAME created successfully"
  else
    echo "❌ Failed to create $CONTAINER_NAME"
    exit 1
  fi
done

echo ""
echo "All containers created!"
echo ""
echo "Container list:"
lxc list

echo ""
echo "Container IPs:"
for i in $(seq 1 $CONTAINER_COUNT); do
  CONTAINER_NAME="${BASE_NAME}-${i}"
  IP=$(lxc info $CONTAINER_NAME | grep "eth0" | grep "inet" | awk '{print $3}' | cut -d'/' -f1)
  echo "$CONTAINER_NAME: $IP"
done
