#!/bin/bash

GRAFANA_URL="${1?Please specify grafana URL}"
GRAFANA_USER="${2?Please specify grafana admin user}"
GRAFANA_PASSWORD="${3?Please specify grafana password}"

if ! jq --version &> /dev/null
then
    echo "jq is not installed. Please install jq https://jqlang.github.io/jq/download/"
    exit 1
fi

# Add User
echo "Creating user"
curl -XPOST -u "${GRAFANA_USER}:${GRAFANA_PASSWORD}" \
    -H "Content-Type: application/json" \
    "${GRAFANA_URL}/api/admin/users" \
    -d "@user.json"

DASHBOARD_UIDS=`curl -u "${GRAFANA_USER}:${GRAFANA_PASSWORD}" "${GRAFANA_URL}/api/search" | jq ".[] | select( .type == \"dash-db\" ) | .uid " | tr -d '"'`
for DASHBOARD_UID in ${DASHBOARD_UIDS}; do
    echo "Granting view permission to dashboard ${DASHBOARD_UID}"
    curl -XPOST -u "${GRAFANA_USER}:${GRAFANA_PASSWORD}" \
        -H "Content-Type: application/json" \
        "${GRAFANA_URL}/api/access-control/dashboards/${DASHBOARD_UID}/builtInRoles/Viewer" \
        -d '{"permission": "View"}'
done

echo "Done"
