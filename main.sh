#!/usr/bin/env bash

# Copyright The Helm Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

export SCRIPT_DIR=$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}" || realpath "${BASH_SOURCE[0]}")")

main() {
    args=()

    if [[ -z "${INPUT_ACTION}" ]]; then
        echo "Action missing, please define it in workflow action:"
        exit 1
    fi

    "$SCRIPT_DIR/$INPUT_ACTION.sh"
}

main

# "$SCRIPT_DIR/package.sh"
# "$SCRIPT_DIR/test.sh"
# "$SCRIPT_DIR/publish.sh"
