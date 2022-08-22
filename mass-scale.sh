#!/bin/bash

PROJECT=""
REPLICAS=1

while getopts p:r: flag; do
  case "${flag}" in
    p)
      PROJECT=${OPTARG}
      ;;
    r)
      REPLICAS=${OPTARG}
      ;;
  esac
done

switch_project() {
  oc project "${PROJECT}"
}

get_dc() {
  echo "Get deployment config ..."
  oc get dc --no-headers -o custom-columns=NAME:.metadata.name > /tmp/tmp-dcs.txt
}

scale_dc() {
  get_dc
  while read dc; do
    echo "Scaling ${dc} to ${REPLICAS} replicas ..."
    oc scale --replicas=${REPLICAS} --namespace=${PROJECT} dc ${dc}
  done < /tmp/tmp-dcs.txt
  rm -f /tmp/tmp-dcs.txt
}

switch_project \
  && scale_dc
