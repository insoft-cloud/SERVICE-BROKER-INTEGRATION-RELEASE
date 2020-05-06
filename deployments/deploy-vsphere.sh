#!/bin/bash

# SET VARIABLES
export DEPLOYMENT_NAME='service-broker-integration'
export BOSH2_NAME='boshd'

# DEPLOY
bosh -e ${BOSH2_NAME} -n -d ${DEPLOYMENT_NAME} deploy --no-redact manifest/service-broker-integration-vsphere.yml \
    -l manifest/vars-vsphere.yml \
    -v director_name=${BOSH2_NAME} \
    -v deployment_name=${DEPLOYMENT_NAME}
