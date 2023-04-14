#!/bin/bash

if [ -z "$FALCON_CLOUD" ]; then
  echo "FALCON_CLOUD is not set, and is required to be set to the cloud instance you are using. For example, https://api.crowdstrike.com"
  exit 1
fi

if [ -z "$FALCON_CLIENT_ID" ]; then
  echo "FALCON_CLIENT_ID is not set, and is required to be set to the client ID of the API key you are using"
  exit 1
fi

if [ -z "$FALCON_CLIENT_SECRET" ]; then
  echo "FALCON_CLIENT_SECRET is not set, and is required to be set to the client secret of the API key you are using"
  exit 1
fi

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
KPA_RESPONSE=$(curl -s -X GET \
  -H "Authorization: Bearer $FALCON_ACCESS_TOKEN" \
  "${FALCON_CLOUD}/kubernetes-protection/entities/integration/agent/v1?cluster_name=example_cluster&is_self_managed_cluster=true")

DOCKER_ACCESS_TOKEN=$(echo "$KPA_RESPONSE" | awk -F ': ' '/dockerAPIToken:/ {print $2}')
FALCON_CCID=$(echo "$KPA_RESPONSE" | awk -F ': ' '/cid:/ {print $2}')

echo "Docker Access Token: $DOCKER_ACCESS_TOKEN"
echo "Falcon CCID: $FALCON_CCID"
