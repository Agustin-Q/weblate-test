#!/bin/bash

# Extract the branch name
branch_name=$(echo $GITHUB_REF | sed -n 's/refs\/heads\///p')
echo "Branch name: $branch_name"
if [ -n "$branch_name" ]; then
    # Make the first HTTP request
    first_response=$(curl -X GET -I "http://localhost/api/components/test/$branch_name/" --header 'Authorization: Token wlu_rensMNoF5IKETTAQnydrhi8ZXgMDQ5IBq4XG' -s -w '%{http_code}' -o /dev/null)
    echo $first_response
    # Check if the first response status is 404
    if [ "$first_response" == "404" ]; then
        json_data=$(cat weblate-component-template.json)
        # Replace the placeholder with the actual branch name
        json_data=${json_data//BRANCH_NAME/$branch_name}
        # Make the second HTTP request
        second_response=$(curl --location "http://localhost/api/projects/test/components/" \
        --header 'Content-Type: application/json' \
        --header 'Authorization: Token wlu_rensMNoF5IKETTAQnydrhi8ZXgMDQ5IBq4XG' \
        --data-raw "$json_data")
    
    # Add your logic to handle the second response here
    fi
fi
# You can print or use the responses as needed
echo "First Response: $first_response"
echo "Second Response: $second_response"
