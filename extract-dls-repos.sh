#!/usr/bin/env bash

ORG="DiamondLightSource"
# This token should be inputted at runtime within k8
#TOKEN="SET-AT-RUNTIME-INSTEAD"

REPOS=()
page=1

while true; do
    response=$(curl -s -H "Authorization: token $TOKEN" \
        "https://api.github.com/orgs/$ORG/repos?per_page=100&page=$page")
        
    echo $response

    # Extract URLs
    urls=$(echo "$response" | jq -r '.[].html_url')

    # Stop if no more repos
    if [[ -z "$urls" ]]; then
        break
    fi

    # Append to array
    while IFS= read -r url; do
        REPOS+=("$url")
    done <<< "$urls"

    ((page++))
done

# Print array contents
printf "%s\n" "${REPOS[@]}"