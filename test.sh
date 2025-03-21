#!/bin/bash
set -e

do_template() {
    local chart="deployments/${1}"
    local values="deployments/${1}/values.yaml"
    shift
    helm template "${chart}" -f "${values}" "${@}" >/dev/null 2>&1
}

# ###
# Validate version pin logic
# ###
echo "Validating version pin logic"
query='select(.kind == "ConfigMap").data.SDM_DISABLE_UPDATE'
for chart in "sdm-relay" "sdm-proxy"; do
    [[ $(do_template "${chart}" --set strongdm.image.tag=100.0.0 | yq -r "${query}") == "true" ]]
    [[ $(do_template "${chart}" --set strongdm.image.tag=latest  | yq -r "${query}") == "false" ]]
    [[ $(do_template "${chart}" --set strongdm.image.tag=latest  | yq -r "${query}") == "false" ]]
    [[ $(do_template "${chart}"                                  | yq -r "${query}") == "false" ]]
done



echo "***"
echo "Validating sdm-relay auth combos"
echo "***"
echo -n "* no inputs "
do_template sdm-relay && echo '❌' || echo '✅'

echo -n "* --set strongdm.auth.secretName=foo "
do_template sdm-relay --set strongdm.auth.secretName=foo && echo '✅' || echo '❌'

echo -n "* --set strongdm.auth.adminToken=foo "
do_template sdm-relay --set strongdm.auth.adminToken=foo && echo '✅' || echo '❌'

echo -n "* --set strongdm.auth.relayToken=foo "
do_template sdm-relay --set strongdm.auth.relayToken=foo && echo '❌' || echo '✅'

echo -n "* --set strongdm.auth.relayToken=foo --set strongdm.autoCreateNode=false "
do_template sdm-relay --set strongdm.auth.relayToken=foo --set strongdm.autoCreateNode.enabled=false && echo '✅' || echo '❌'

echo "***"
echo "Validating sdm-proxy auth combos"
echo "***"
echo -n "-- no inputs "
do_template sdm-proxy && echo '❌' || echo '✅'

echo -n "* --set strongdm.auth.secretName=foo "
do_template sdm-relay --set strongdm.auth.secretName=foo && echo '✅' || echo '❌'

echo -n "* --set strongdm.auth.adminToken=foo "
do_template sdm-relay --set strongdm.auth.adminToken=foo && echo '✅' || echo '❌'

echo -n "* --set strongdm.auth.clusterKey=foo "
do_template sdm-relay --set strongdm.auth.clusterKey=foo && echo '❌' || echo '✅'

echo -n "* --set strongdm.auth.clusterKey=foo --set strongdm.auth.clusterSecret=foo "
do_template sdm-relay --set strongdm.auth.clusterKey=foo --set strongdm.auth.clusterSecret=foo && echo '✅' || echo '❌'
