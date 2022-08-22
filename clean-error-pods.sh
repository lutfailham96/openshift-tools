#!/bin/bash

PROJECT="default"

while getopts p: flag; do
  case "${flag}" in
    p)
      PROJECT=${OPTARG}
      ;;
  esac
done

switch_project() {
  oc project ${PROJECT}
}

get_pods() {
  echo "Get error pods ..."
  oc get pods --namespace "${PROJECT}" | grep Error | awk '{print $1}' > /tmp/error-pods.txt
}

clean_pods() {
  get_pods
  while read -r pod; do
    echo "Clean error pod: ${pod} ..."
    oc delete pods "${pod}" --namespace "${PROJECT}"
  done < /tmp/error-pods.txt
  rm -f /tmp/error-pods.txt
}

switch_project \
  && clean_pods
