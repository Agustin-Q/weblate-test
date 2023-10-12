#!/bin/bash

weblate_url=http://localhost
project_slug="test"
# Extract the branch name
branch_name=$(echo $GITHUB_REF | sed -n 's/refs\/heads\///p')
echo "Branch name: $branch_name"
if [ -n "$branch_name" ]; then
    # Revisar si el componente ya existe
    component_exists=$(curl -X GET -I "$weblate_url/api/components/$project_slug/$branch_name/" --header 'Authorization: Token wlu_rensMNoF5IKETTAQnydrhi8ZXgMDQ5IBq4XG' -s -w '%{http_code}' -o /dev/null)
    echo $component_exists
    # si es 404 creamos el componente
    if [ "$component_exists" == "404" ]; then
        #cargar datos del templates para el payload
        json_data=$(cat weblate-component-template.json)
        # Reemplazar las variables en el template
        json_data=${json_data//BRANCH_NAME/$branch_name}
        component_slug=$(echo "$branch_name" | sed -e 's/[/]/_/g' -e 's/[.]/-/g')
        echo "Component slug: $component_slug"
        json_data=${json_data//COMPONENT_SLUG/$component_slug}
        # Crear el componente
        create_component_response=$(curl --location "$weblate_url/api/projects/$project_slug/components/" \
        --header 'Content-Type: application/json' \
        --header 'Authorization: Token wlu_rensMNoF5IKETTAQnydrhi8ZXgMDQ5IBq4XG' \
        --data-raw "$json_data")
    fi
fi

echo "First Response: $component_exists"
echo "Second Response: $create_component_response"
