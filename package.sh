#!/bin/bash -l
set -eo pipefail

source $SCRIPT_DIR/common.sh

install_helm

helm init --client-only
echo "==> Helm add repo"
helm repo add $HELM_PULL_REPO $REGISTRY/$HELM_REPO --username $RT_USERNAME --password $RT_APIKEY
helm repo update

echo "==> Helm dependency build"
helm dependency build $CHART_DIR

echo "==> Linting"
helm lint $CHART_DIR

echo "==> Helm package"
helm package $CHART_DIR
