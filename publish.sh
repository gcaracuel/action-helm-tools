#/bin/bash -l
set -eo pipefail

source $SCRIPT_DIR/common.sh

export JFROG_CLI_OFFER_CONFIG=false

install_jfrog

echo "==> Check published version of $CHART_NAME"

if jfrog rt s "$HELM_PUSH_REPO/$CHART_NAME-v$VERSION.tgz" --url $REGISTRY --apikey $ARTIFACTORY_PASSWORD --fail-no-op; then
    printf "$CHART_NAME-v$VERSION already exist in artifactory $HELM_PUSH_REPO, exit\n"
    exit 0
else
    printf "==> Attempting to upload:\n$CHART_NAME-$VERSION.tgz\nto $REGISTRY/${HELM_PUSH_REPO}\n"
    jfrog rt u $RUNNER_WORKSPACE/$CHART_NAME-v$VERSION.tgz $HELM_PUSH_REPO --url $REGISTRY --apikey $ARTIFACTORY_PASSWORD --fail-no-op || exit 1
fi
