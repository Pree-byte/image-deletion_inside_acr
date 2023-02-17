#!/bin/bash

# WARNING! This script deletes data!
# Run only if you do not have systems
# that pull images via manifest digest.

# Change to 'true' to enable image delete
ENABLE_DELETE=true

# Modify for your environment
REGISTRY=$1
TIMESTAMP=$2

# Delete all images older than specified timestamp in all repositories.

if [ "$ENABLE_DELETE" = true ]
then
    for REPOSITORY in $(az acr repository list --name $REGISTRY --query "[]" -o tsv)
    do
        az acr manifest list-metadata --name $REPOSITORY --registry $REGISTRY \
        --orderby time_asc --query "[?lastUpdateTime < '$TIMESTAMP'].digest" -o tsv \
        | xargs -I% az acr repository delete --name $REGISTRY --image $REPOSITORY@% --yes
    done
else
    echo "No data deleted."
    echo "Set ENABLE_DELETE=true to enable deletion of these images in all repositories:"
    for REPOSITORY in $(az acr repository list --name $REGISTRY --query "[].name" -o tsv)
    do
        echo "Repository: $REPOSITORY"
        az acr manifest list-metadata --name $REPOSITORY --registry $REGISTRY \
       --orderby time_asc --query "[?lastUpdateTime < '$TIMESTAMP'].[digest, lastUpdateTime]" -o tsv
    done
fi


