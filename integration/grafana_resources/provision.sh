#!/bin/bash

GRAFANA_URL="${1?Please specify grafana URL}"
GRAFANA_USER="${2?Please specify grafana admin user}"
GRAFANA_PASSWORD="${3?Please specify grafana password}"

if ! jq --version &> /dev/null
then
    echo "jq is not installed. Please install jq https://jqlang.github.io/jq/download/"
    exit 1
fi

# Add Users
echo "Creating read_only user"
curl -XPOST -u "${GRAFANA_USER}:${GRAFANA_PASSWORD}" \
    -H "Content-Type: application/json" \
    "${GRAFANA_URL}/api/admin/users" \
    -d "@read_only.json"

# Add Users
echo "Creating read_write user"
USER_ID=`curl -XPOST -u "${GRAFANA_USER}:${GRAFANA_PASSWORD}" \
    -H "Content-Type: application/json" \
    "${GRAFANA_URL}/api/admin/users" \
    -d "@read_write.json" | jq .id`

echo "User created with id ${USER_ID}"
curl -XPATCH -u "${GRAFANA_USER}:${GRAFANA_PASSWORD}" \
    -H "Content-Type: application/json" \
    "${GRAFANA_URL}/api/orgs/1/users/${USER_ID}" \
    -d '{"role": "Editor"}'

DASHBOARD_UIDS=`curl -u "${GRAFANA_USER}:${GRAFANA_PASSWORD}" "${GRAFANA_URL}/api/search" | jq ".[] | select( .type == \"dash-db\" ) | .uid " | tr -d '"'`
for DASHBOARD_UID in ${DASHBOARD_UIDS}; do
    echo "Granting view permission to dashboard ${DASHBOARD_UID}"
    curl -XPOST -u "${GRAFANA_USER}:${GRAFANA_PASSWORD}" \
        -H "Content-Type: application/json" \
        "${GRAFANA_URL}/api/access-control/dashboards/${DASHBOARD_UID}/builtInRoles/Viewer" \
        -d '{"permission": "View"}'

    echo "Granting edit permission to dashboard ${DASHBOARD_UID}"
    curl -XPOST -u "${GRAFANA_USER}:${GRAFANA_PASSWORD}" \
        -H "Content-Type: application/json" \
        "${GRAFANA_URL}/api/access-control/dashboards/${DASHBOARD_UID}/builtInRoles/Editor" \
        -d '{"permission": "Edit"}'
done

echo "Done"
