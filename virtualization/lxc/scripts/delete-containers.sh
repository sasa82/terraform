##!/bin/bash

## Usage: ./delete-containers.sh <number-of-containers> <base-name>
## Example: ./delete-containers.sh 3 clickhouse

CONTAINER_COUNT=${1:-3}
BASE_NAME=${2:-"test-node"}

echo "Deleting $CONTAINER_COUNT LXC containers..."

for i in $(seq 1 $CONTAINER_COUNT); do
  CONTAINER_NAME="${BASE_NAME}-${i}"
  echo "Deleting container: $CONTAINER_NAME"

  ## Stop container first
  lxc stop $CONTAINER_NAME --force 2>/dev/null

  ## Delete container
  lxc delete $CONTAINER_NAME

  if [ $? -eq 0 ]; then
    echo "✅ $CONTAINER_NAME deleted successfully"
  else
    echo "❌ Failed to delete $CONTAINER_NAME"
  fi
done

echo ""
echo "Remaining containers:"
lxc list
