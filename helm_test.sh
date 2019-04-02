#!/bin/sh

# Script to run helm test and pipe the output to terminal

helm_release=$1

helm test $helm_release  --timeout=10

test_pods=$(helm status $helm_release -o json | jq -r .info.status.last_test_suite_run.results[].name)
namespace=$(helm status $helm_release -o json | jq -r .namespace)

echo "Running in namespace: $namespace"
for test_pod in $test_pods; do
  echo "Test Pod: $test_pod"
  echo "============"
  echo ""
  kubectl -n $namespace logs $test_pod
  kubectl -n $namespace delete pod $test_pod
  echo ""
  echo "============"
done
