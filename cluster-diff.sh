#!/bin/bash

cluster_scoped_resources=(
"performanceprofiles.performance.openshift.io"
"networks.operator.openshift.io cluster .spec.disableNetworkDiagnostics"
"OperartorHub cluster"
"mc container-mount-namespace-and-kubelet-conf-master"
"mc 07-sriov-related-kernel-args-master"
"mc 08-set-rcu-normal-master"
"mc 99-crio-disable-wipe-master"
"mc 99-sync-time-once-master"
)

namespaced_resources=(
  "openshift-cluster-node-tuning-operator tuned performance-patch"
  "openshift-monitoring cm cluster-monitoring-config"
  "openshift-operator-lifecycle-manager cm collect-profiles-config"
  "openshift-marketplace catalogsource redhat-operators"
  "openshift-marketplace catalogsource certified-operators"

)

usage(){
  echo "The script will compare 2 OpenShift clusters."
  echo "Usage: $0 kubeconfig_file1 kubeconfig_file2"
  echo "Example: $0 kubeconfig-sno1.yaml kubeconfig-sno2.yaml"
}


if [ $# -lt 2 ]
then
  usage
  exit
fi

if [[ ( $@ == "--help") ||  $@ == "-h" ]]
then
  usage
  exit
fi

oc1="oc --kubeconfig=$1"
oc2="oc --kubeconfig=$2"

compare_cluster_scoped_resources(){
  crd=$1
  name=$2
  jsonpath=$3

  echo "Diff $crd $name"

  if [ -n "$name" ]; then
    source_file="source-$crd-$name.yaml"
    target_file="target-$crd-$name.yaml"
  else
    source_file="source-$crd.yaml"
    target_file="target-$crd.yaml"
  fi

  if [ -z "$name" ]; then
    $oc1 get "$crd" -o yaml |yq ".items[0]" > "$source_file"
    $oc2 get "$crd" -o yaml |yq ".items[0]" > "$target_file"

  else
    if [ -n "$jsonpath" ]; then
      $oc1 get "$crd" "$name" -o yaml | yq "$jsonpath" > "$source_file"
      $oc2 get "$crd" "$name" -o yaml | yq "$jsonpath" > "$target_file"
    else
      $oc1 get "$crd" "$name" -o yaml > "$source_file"
      $oc2 get "$crd" "$name" -o yaml > "$target_file"
    fi
  fi

  yq -i 'del(.status)|.metadata |= with_entries(select(.key == "name"))' "$source_file"
  yq -i 'del(.status)|.metadata |= with_entries(select(.key == "name"))' "$target_file"

  yq -i -P 'sort_keys(..)' "$source_file"
  yq -i -P 'sort_keys(..)' "$target_file"

  diff --color -y "$source_file" "$target_file"
}

compare_namespaced_scoped_resources(){
  ns=$1
  crd=$2
  name=$3

  echo "Diff $ns $crd $name"

  source_file="source-$ns-$crd-$name.yaml"
  target_file="target-$ns-$crd-$name.yaml"

  if [ -n "$4" ]; then
    $oc1 get -n "$ns" "$crd" "$name" -o yaml |yq "$4" > "$source_file"
    $oc2 get -n "$ns" "$crd" "$name" -o yaml |yq "$4" > "$target_file"
  else
    $oc1 get -n "$ns" "$crd" "$name" -o yaml > "$source_file"
    $oc2 get -n "$ns" "$crd" "$name" -o yaml > "$target_file"
  fi

  yq -i 'del(.status)|.metadata |= with_entries(select(.key == "name" or .key == "namespace"))' "$source_file"
  yq -i 'del(.status)|.metadata |= with_entries(select(.key == "name" or .key == "namespace"))' "$target_file"

  yq -i -P 'sort_keys(..)' "$source_file"
  yq -i -P 'sort_keys(..)' "$target_file"

  diff --color -y "$source_file" "$target_file"
}


if [ -f $1 ] && [ -f $2 ]; then
  echo "Compare cluster-scoped resources"
  while read crd name jsonpath; do
    compare_cluster_scoped_resources "$crd" "$name" "$jsonpath"
    echo ------------------------------------------------------------------------------------------------
    echo
  done < <(printf '%s\n' "${cluster_scoped_resources[@]}")


  while read ns crd name jsonpath; do
    echo "Compare namespace-scoped resources"
    compare_namespaced_scoped_resources $ns $crd $name $jsonpath
    echo ------------------------------------------------------------------------------------------------
    echo
  done < <(printf '%s\n' "${namespaced_resources[@]}")

else
  echo "$1 or $2 not exist, please check"
  exit -1
fi
