#!/bin/bash -l
set -o pipefail
# set -x

# Get tags, latest release and its commit sha
git fetch --depth=1 origin +refs/tags/*:refs/tags/* || true
LATEST_RELEASE=$(git describe --tags `git rev-list --tags --max-count=1`) # get latest

if [ -z "$LATEST_RELEASE" ]; then
    LATEST_RELEASE="v0.0.0"
    _sha=$(git rev-list -n 1 HEAD)
else
    _sha=$(git rev-list -n 1 $LATEST_RELEASE)
fi

LATEST_RELEASE=${LATEST_RELEASE#v}
SHORT_TAG_SHA=${_sha:0:7}

# On tag push set MAKE_RELEASE variable to true
if [ -z "${MAKE_RELEASE:-}" ]; then
    VERSION="$LATEST_RELEASE-$SHORT_TAG_SHA"
else
    VERSION=${GITHUB_REF#*/v} # Get version 1.2.3 from GITHUB_REF="refs/tags/v1.2.3"
fi

export LATEST_RELEASE
export SHORT_TAG_SHA
export VERSION
echo $VERSION
