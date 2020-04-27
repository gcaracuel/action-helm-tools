#!/bin/bash -l
set -o pipefail
# set -x

git fetch --depth=1 origin +refs/tags/*:refs/tags/* || true
# Get latest release
LATEST_RELEASE=$(git describe --tags `git rev-list --tags --max-count=1`)
_sha=$(git rev-list -n 1 HEAD)

[ -z "$LATEST_RELEASE" ] && LATEST_RELEASE="v0.0.0"

LATEST_RELEASE=${LATEST_RELEASE#v}
SHORT_TAG_SHA=${_sha:0:7}

# On tag push set MAKE_RELEASE variable to true
if [ -z "${MAKE_RELEASE:-}" ]; then
    VERSION="$LATEST_RELEASE-$SHORT_TAG_SHA"
else
    # Get version 1.2.3 from gh actions env var GITHUB_REF="refs/tags/v1.2.3"
    VERSION=${GITHUB_REF#*/v}
fi

export LATEST_RELEASE
export SHORT_TAG_SHA
export VERSION
echo $VERSION
