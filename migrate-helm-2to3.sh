#!/bin/bash

set -e

HELM_2_VERSION="2.16.11"
HELM_3_VERSION="3.5.3"
TILLER_NAMESPACE=""
RELEASE_NAME=""

migrate_helm_2_to_3() {
  # Switch to Helm 3
  helmswitch "${HELM_3_VERSION}"

  # Convert Release to Helm 3
  helm 2to3 convert "${RELEASE_NAME}" --tiller-ns "${TILLER_NAMESPACE}" --release-versions-max 5 || echo "There was an error migrating ${RELEASE_NAME} to Helm 3 "
  helm 2to3 cleanup --name "${RELEASE_NAME}" --tiller-ns "${TILLER_NAMESPACE}" --release-cleanup --skip-confirmation || echo "There was an error cleaning Helm 2 releases ${RELEASE_NAME} to Helm 3 "
}

get_helm_release_status() {
  case $1 in
  "2")
    helmswitch "${HELM_2_VERSION}" >/dev/null 2>&1
    echo "$(helm status ${RELEASE_NAME} -o json | jq -r .info.status.code)"
    ;;
  "3")
    helmswitch "${HELM_3_VERSION}" >/dev/null 2>&1
    echo "$(helm status ${RELEASE_NAME} -o json | jq -r .info.status)"
    ;;
  *)
    echo "helm version $1 not defined"
    ;;
  esac
}

## Helm init
helmswitch "${HELM_2_VERSION}" &&
  helm init --client-only --skip-refresh >/dev/null 2>&1
helm repo remove stable || true

HELM2_DEPLOYED=""

## Start of Helm 3 migration logic
echo "###########################################"

echo "Checking the Helm deployment status for ${RELEASE_NAME} status on Helm 2"
release_status=$(get_helm_release_status 2)

if [ -n "${release_status// /}" ] && [ "${release_status// /}" -gt 0 ]; then
  echo "${RELEASE_NAME} is deployed with helm 2"
  HELM2_DEPLOYED="true"
  echo "Migrating ${RELEASE_NAME} to Helm 3"
  migrate_helm_2_to_3
else
  echo "${RELEASE_NAME} is NOT deployed using Helm 2"
  HELM2_DEPLOYED="false"
fi

echo "###########################################"
