#/bin/bash -l
set -eo pipefail

source $SCRIPT_DIR/common.sh

export JFROG_CLI_OFFER_CONFIG=false

install_jfrog

echo "==> Check published version of $CHART_NAME"
remote=$(mktemp)
jfrog rt s "$HELM_PUSH_REPO/$CHART_NAME*.tgz" --url $REGISTRY --apikey $RT_APIKEY | jq ".[].path" | jq -rM 'gsub("('$HELM_PUSH_REPO'/)"; "")' >> $remote
new_tgz=$(ls -1 *.tgz | grep -vFf $remote || true)
if [ -z "$new_tgz" ]; then
    printf "No new version to upload\n"
    exit 0
fi

printf "==> Attempting to upload:\n$new_tgz\n\n"
regex=""
for tgz in $new_tgz; do
    regex="$regex($tgz)|"
done
regex=${regex::-1}

jfrog rt u $regex $HELM_PUSH_REPO --regexp --url $REGISTRY --apikey $RT_APIKEY
