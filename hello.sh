echo "This is demo"

docker login acrpreet.azurecr.io  --username $username --password $password

az acr repository list -n $registryname

