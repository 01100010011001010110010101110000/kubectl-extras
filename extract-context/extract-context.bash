#!/usr/bin/env bash
# Prints a kubeconfig YAML file for the specified context by minifying the file
# and redacting the access token.
set -eo pipefail


test -z "$1" && echo "context name required." 1>&2 && exit 1
ctx="$1"

cur_ctx="$(kubectl config current-context)"
if [[ -z "${cur_ctx}" ]]; then
    echo >&2 "current context is not set"
    exit 1
fi

kubectl config use-context "${ctx}" || (
    echo >&2 "failed to switch to context"
    exit 1
)

kubectl config view --minify --flatten | \
    grep -v 'access-token:' | \
    grep -v 'expiry:'

kubectl config use-context "${cur_ctx}" 2>&1 1>/dev/null
