#configure Resource Group and Container App Environment

az account set --subscription 1ec69190-43a6-454c-a2c6-0ef8d619dc19

az extension add --name containerapp --upgrade

az provider register --namespace Microsoft.App

az provider register --namespace Microsoft.OperationalInsights

RESOURCE_GROUP="dapr-unleashed"
LOCATION="northeurope"
CONTAINERAPPS_ENVIRONMENT="dapr-unleashed"
CONTAINERAPP_1="ingestion"
CONTAINERAPP_2="transformation"
CONTAINERAPP_3="extraction"
REGISTRY_SERVER="demodaprunleashedacr.azurecr.io"
IMAGE_1="$REGISTRY_SERVER/daprunleashed-api:daprunleashed"
IMAGE_2="$REGISTRY_SERVER/daprunleashed-extractionservice:daprunleashed"
IMAGE_3="$REGISTRY_SERVER/daprunleashed-transformationservice:daprunleashed"

LOG_ANALYTICS_WORKSPACE_ID="1607fba5-01e0-4c6c-b8e3-0691bda5f5a7"

az group create --name $RESOURCE_GROUP --location $LOCATION

# configure container app environment

az containerapp env create --name $CONTAINERAPPS_ENVIRONMENT --resource-group $RESOURCE_GROUP --location "$LOCATION" --logs-workspace-id $LOG_ANALYTICS_WORKSPACE_ID

#configure dapr components

az containerapp env dapr-component set --name $CONTAINERAPPS_ENVIRONMENT --resource-group $RESOURCE_GROUP --dapr-component-name pubsub --yaml ../components_aca/servicebus.yaml

az containerapp env dapr-component set --name $CONTAINERAPPS_ENVIRONMENT --resource-group $RESOURCE_GROUP --dapr-component-name promptstore --yaml ../components_aca/cosmosdb.yaml


# configure container apps

az containerapp create -n $CONTAINERAPP_1 -g $RESOURCE_GROUP --environment $CONTAINERAPPS_ENVIRONMENT --ingress external --target-port 80 --enable-dapr true --registry-server $REGISTRY_SERVER --registry-identity system --image $IMAGE_1 --min-replicas 1 --max-replicas 1
az containerapp create -n $CONTAINERAPP_2 -g $RESOURCE_GROUP --environment $CONTAINERAPPS_ENVIRONMENT --enable-dapr true --registry-server $REGISTRY_SERVER --registry-identity system --image $IMAGE_2 --min-replicas 1 --max-replicas 1
az containerapp create -n $CONTAINERAPP_3 -g $RESOURCE_GROUP --environment $CONTAINERAPPS_ENVIRONMENT --enable-dapr true --registry-server $REGISTRY_SERVER --registry-identity system --image $IMAGE_3 --min-replicas 1 --max-replicas 1


# Compose
# az containerapp compose create --environment $CONTAINERAPPS_ENVIRONMENT --resource-group $RESOURCE_GROUP --location "$LOCATION" --compose-file-path ./docker-compose-aca.yml