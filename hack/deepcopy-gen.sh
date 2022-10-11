#!/usr/bin/env bash
# retrieved from https://github.com/kubernetes/code-generator/blob/master/generate-internal-groups.sh
# and adapted to only install and run the deepcopy-gen

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_ROOT=$(dirname "${BASH_SOURCE[0]}")/..
echo "Script root is $SCRIPT_ROOT"

GENS="$1"
shift 1

(
  # To support running this script from anywhere, first cd into this directory,
  # and then install with forced module mode on and fully qualified name.
  # make sure your GOPATH env is properly set.
  # it will go under $GOPATH/bin
  cd "$(dirname "${0}")"
  GO111MODULE=on go install k8s.io/code-generator/cmd/deepcopy-gen@latest
)

function codegen::join() { local IFS="$1"; shift; echo "$*"; }

if [ "${GENS}" = "all" ] || grep -qw "deepcopy" <<<"${GENS}"; then
  echo "Generating deepcopy funcs"
  export GO111MODULE=off
  "${GOPATH}/bin/deepcopy-gen" -v 4 \
      --input-dirs github.com/serverlessworkflow/sdk-go/model -O zz_generated.deepcopy \
      --go-header-file "${SCRIPT_ROOT}/hack/boilerplate.txt" \
      "$@"
fi
