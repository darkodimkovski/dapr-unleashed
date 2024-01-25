# Prerequisites
# Dapr CLI
# kubectl

az login

RESOURCE_GROUP="dapr-unleashed"
AKS_CLUSTER_NAME="dapr-unleashed"

# create AKS cluster

az aks create --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME --node-count 1 --enable-addons http_application_routing --generate-ssh-keys

# get AKS credentials and merge into the .kube/config file so kubectl can use them

az aks get-credentials -n $AKS_CLUSTER_NAME -g $RESOURCE_GROUP

# Check current context

kubectl config get-contexts

# Initialize Dapr on AKS cluster

dapr init -k

# Open Dapr dashboard in local browser via local proxy to Kubernetes cluster

dapr dashboard -k

# Check the status of the dapr pods

dapr status -k

# Apply the components to have them auto-injected into application pods

kubectl apply -f ./deploy/pubsub.yaml

kubectl create -f ./deploy/azurekeyvault.yaml

kubectl apply -f ./deploy/promptstore.yaml

# Deploy the app to AKS

