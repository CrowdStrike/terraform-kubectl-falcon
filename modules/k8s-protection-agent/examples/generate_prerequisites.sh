#!/bin/bash

# Set variables
FALCON_CLOUD=${FALCON_CLOUD}
FALCON_CLIENT_ID=${FALCON_CLIENT_ID}
FALCON_CLIENT_SECRET=${FALCON_CLIENT_SECRET}

if ! echo "$FALCON_CLOUD" | grep -q "^https://"; then
  FALCON_CLOUD="https://$FALCON_CLOUD"
fi

# Get Falcon Access Token
FALCON_ACCESS_TOKEN=$(curl -s -X POST \
  -H "Accept: */*" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=$FALCON_CLIENT_ID&client_secret=$FALCON_CLIENT_SECRET" \
  "$FALCON_CLOUD/oauth2/token" | jq -r '.access_token')

# Get Docker Access Token
DOCKER_ACCESS_TOKEN=$(curl -s -X GET \
  -H "Authorization: Bearer $FALCON_ACCESS_TOKEN" \
  "$FALCON_CLOUD/container-security/entities/image-registry-credentials/v1" | jq -r '.resources[0].token')

# Get CCID
FALCON_CCID=$(curl -s -X GET \
  -H "Authorization: Bearer $FALCON_ACCESS_TOKEN" \
  "$FALCON_CLOUD/sensors/queries/installers/ccid/v1" | jq -r '.resources[0]')

echo "Docker Access Token: $DOCKER_ACCESS_TOKEN"
echo "Falcon CCID: $FALCON_CCID"
