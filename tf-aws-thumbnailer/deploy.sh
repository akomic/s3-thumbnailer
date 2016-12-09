#!/usr/bin/env bash

[ ! -f "config.sh" ] && echo "config.sh file is missing, aborting." && exit 1

if [ ! -z $1 ] && ( [ "${1}" = "plan" ] || [ "${1}" = "apply" ] || [ "${1}" = "destroy" ] ); then
    TF_CMD=$1
else
    TF_CMD="plan"
fi

echo "Starting ECS deploy: ${TF_CMD}"
source config.sh

echo "Configuring remote state: ${remote_state_s3_bucket}/${StackName}-${UniqueID}/thumbnailer.state"
terraform remote config -backend=s3 -backend-config="bucket=${remote_state_s3_bucket}" -backend-config="key=${StackName}-${UniqueID}/thumbnailer.state"

# echo "Getting dependent tf modules"
# terraform get -update

set -x
terraform ${TF_CMD} \
    -var stackname=${StackName} \
    -var UniqueID=${UniqueID} \
    -var cluster_arn=${cluster_arn} \
    -var DOCKER_IMAGE=${DOCKER_IMAGE} \
    -var remote_state_s3_bucket=${remote_state_s3_bucket} \
    -var AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} \
    -var desired_count=${desired_count} \
    -var deployment_maximum_percent=${deployment_maximum_percent} \
    -var deployment_minimum_healthy_percent=${deployment_minimum_healthy_percent}

set +x
