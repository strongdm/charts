#!/bin/bash
set -e -u -o pipefail
trap "rm /tmp/*.tgz || true" 0

echo "--- :git: Get PR labels"
if [[ "${BUILDKITE_PULL_REQUEST}" == "false" ]]; then
    pr_number="$(echo "${BUILDKITE_MESSAGE}" | awk -F '#' '{print $2}' | awk '{print $1}' | tr -d '()')"
else
    pr_number="${BUILDKITE_PULL_REQUEST}"
fi

all_labels="$(curl -sL -H "Authorization: Bearer ${GITHUB_TOKEN}" "https://api.github.com/repos/strongdm/control-plane-helm-chart/pulls/${pr_number}" | jq -r '.labels')"
if [[ $(jq '. | length' <<< "${all_labels}") -ne 1 ]]; then
    echo "Please add a software label to your PR"
    exit 1
fi
pr_label="$(jq -r '.[].name' <<< "${all_labels}")"

echo "--- :git: Bump version"
git fetch --tags --force --quiet
IFS='.' read -r x y z <<< "$(git tag --sort=-v:refname | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | head -n 1)"
if [[ "${pr_label}" == "major" ]]; then
    ((x++))
    version="${x}.0.0"
elif [[ "${pr_label}" == "minor" ]]; then
    ((y++))
    version="${x}.${y}.0"
elif [[ "${pr_label}" == "patch" ]]; then
    ((z++))
    version="${x}.${y}.${z}"
elif [[ "${pr_label}" == "integration" ]]; then
    echo "Not creating new chart version for integration build"
    exit 0
else
    echo "PR is missing a label"
    exit 1
fi
buildkite-agent meta-data set "version" "${version}"

echo "--- :helm: Package and push ${version}"
helm package "deployments/sdm-${software}" --destination stable/ --version "${version}"
helm repo index stable

if [[ "${BUILDKITE_PULL_REQUEST}" != "false" ]]; then
    helm push "/stable/sdm-relay-${version}.tgz" oci://522179138863.dkr.ecr.us-west-2.amazonaws.com/helm/
    helm push "/stable/sdm-client-${version}.tgz" oci://522179138863.dkr.ecr.us-west-2.amazonaws.com/helm/
    helm push "/stable/sdm-proxy-${version}.tgz" oci://522179138863.dkr.ecr.us-west-2.amazonaws.com/helm/
fi

# On main builds, update the chart metadata
if [[ "${BUILDKITE_BRANCH}" == "main" ]]; then
    echo "--- :git: Update Chart.yaml to ${version}"
    sed -i "s/^version: .*/version: ${version}/" Chart.yaml
    git commit -am "#${pr_number}"
    git push origin HEAD:main
    git tag "${version}"
    git push origin "${version}"
fi
