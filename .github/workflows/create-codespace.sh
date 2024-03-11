#!/bin/bash

# Replace these variables with your own information
GITHUB_TOKEN="YOUR_GITHUB_TOKEN"
OWNER="your-github-username"
REPO="your-repo-name"
BRANCH="main" # The branch for which you want to create the Codespace

# GitHub API URL for creating a Codespace
API_URL="https://api.github.com/repos/$OWNER/$REPO/codespaces"

# JSON payload specifying the branch and machine type (optional)
# For machine types, refer to https://docs.github.com/en/codespaces/developing-in-codespaces/choosing-a-machine-type-for-your-codespace
# This example uses the default machine type
JSON_PAYLOAD=$(cat <<EOF
{
  "ref": "$BRANCH"
  // "machine": "machine-type" // Uncomment and specify if you want a specific machine type
}
EOF
)

# Making the API call to create a Codespace
response=$(curl -X POST $API_URL \
-H "Authorization: token $GITHUB_TOKEN" \
-H "Accept: application/vnd.github+json" \
-d "$JSON_PAYLOAD")

echo "Response: $response"
