#!/bin/bash

API_URL="https://api.github.com/repos/$GITHUB_REPOSITORY/codespaces"

echo "Codespace being created for $GITHUB_REPOSITORY on branch $BRANCH"

# Make API call to create a Codespace
response=$(curl -X POST $API_URL \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -d "{\"ref\": \"$BRANCH\"}")

codespace_api_url=$(echo $response | jq -r '.url')
codespace_url=$(echo $response | jq -r '.web_url')
echo "Codespace URL: $codespace_url"

# Replace web_url value to get to desired port
app_url=$(echo $codespace_url | sed "s|.github.dev|-${APP_PORT}.app.github.dev|g")

# Wait for Codespace to be ready
echo "Calling app at $app_url to check if it's ready..."
echo "Waiting 30 seconds for Codespace to be ready between attempts..."
for i in {1..20}; do
  # This command uses curl to perform a GET request to the specified app_url 
  # - follows any redirects (-L)
  # - silences progress messages (-s)
  # - discards the downloaded content (-o /dev/null)
  # - writes out only the HTTP status code of the response (-w "%{http_code}") 
  #   to the variable appResponse.
  appResponse=$(curl -L -s -o /dev/null -w "%{http_code}" $app_url)
  if [ "$appResponse" == "200" ]; then
    echo "App is ready"
    break
  else
    echo "Waiting for the app to be ready... attempt $i (HTTP response: $appResponse)"
    sleep 30
  fi
done       

# Delete Codespace
deleteResponse=$(curl -X DELETE $codespace_api_url \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github+json")

echo "Deleted codespace"

