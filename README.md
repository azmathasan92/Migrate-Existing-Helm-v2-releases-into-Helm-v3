# Migrate Existing Helm v2 releases into Helm v3

In this repository you can find the two scripts, one for installing the helmswitch binary and other for migration script. If you dont have helmswitch binary installed in your machine please run the install helmswitch script. This script will install the helmswitch binary and 2to3 helm plugin.

Using migration script you can easily migrate our existing helm 2 releases into helm 3, or you can automate the migration process by applying this script into the deployment pipeline.

## Prerequisite
```
1. Install helmswitch if not installed
2. Authenticate to k8 cluster
3. Updated the TILLER_NAMESPACE and RELEASE_NAME variable in the script
```

## How to run?
```
1. Clone this repo
2. cd migrate-helm-v2-releases-to-helm-v3
3. Follow Prequsite steps
4. chmod +x migrate-helm-2to3.sh
5. ./migrate-helm-2to3.sh
```
