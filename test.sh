#!/bin/bash -l
set -eo pipefail

source $SCRIPT_DIR/common.sh

install_k3d
install_kubectl
install_helm
create_k3d_cluster
setup_tiller

echo "==> Deploy chart $CHART_NAME"
kubectl create namespace $CHART_NAME

if [[ -n "$DOCKER_REGISTRY_SECRET" ]]; then
    kubectl create secret docker-registry --namespace $CHART_NAME $DOCKER_REGISTRY_SECRET \
        --docker-server=$DOCKER_REGISTRY --docker-username=$RT_USERNAME \
        --docker-password=$RT_APIKEY --docker-email=$DOCKER_EMAIL
fi

helm repo add $HELM_REPO_ADD_NAME $REGISTRY/$HELM_REPO --username $RT_USERNAME --password $RT_APIKEY
helm repo update
helm dependency build $CHART_DIR
helm install $CHART_DIR/ --name $CHART_NAME --namespace $CHART_NAME $EXTRA_CMD

check_helm_deployment
