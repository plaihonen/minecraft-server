#!/bin/bash

set -e

echo
echo "Starting local Docker Compose Stack."
echo "Stack is being started in the background."
echo
echo "After the start, we'll follow the logs."
echo "Hit \"Ctrl+C\" in order to stop following the logs"
echo

sleep 5

docker-compose up -d 
docker-compose logs -f

exit 0