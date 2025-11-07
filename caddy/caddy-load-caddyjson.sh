#!/bin/bash

# Check if .env file exists
if [ -f ./.env ]; then
    # export all variables from .env file
    set -a
    source .env
    set +a
else
    echo "ERROR: .env file not found!"
    exit 1
fi

# make request to caddy api
response=$(curl -vsS $CADDY_HOST:$CADDY_API_PORT/load -H "Content-Type: $CADDY_CONTENT_TYPE_JSON" --data @$CADDY_CONFIG_DIR/caddy_config.json)
echo $response