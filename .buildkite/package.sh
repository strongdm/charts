#!/bin/bash
set -e -u -o pipefail

echo "--- :git: Get PR labels"
pr_number="$(echo "${BUILDKITE_MESSAGE}" | awk -F '#' '{print $2}' | awk '{print $1}' | tr -d '()')"

echo "--- :helm: Package"
helm package "deployments/sdm-relay" --destination stable/
helm package "deployments/sdm-client" --destination stable/
helm package "deployments/sdm-proxy" --destination stable/
helm repo index stable

echo "--- :git: Push"
git commit -am "#${pr_number}"
git push origin HEAD:main
