#!/bin/bash

cluster_scoped_resources=(
"clusterversion version"
"nodes.config.openshift.io cluster"
"containerruntimeconfigs"
"performanceprofiles"
"networks.operator.openshift.io cluster .spec.disableNetworkDiagnostics"
"mc container-mount-namespace-and-kubelet-conf-master"
"mc 06-kdump-enable-master"
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
  "openshift-ptp ptpconfig"
  "openshift-ptp ptpoperatorconfig"
  "openshift-sriov-network-operator SriovOperatorConfig"
)


usage(){
  echo "Usage: $0 -s kube1 -t kube2 -h"
  echo "This will compare pre-defined custom resources on 2 clusters specified by kubeconfig files with -s and -t"

  echo "Example: $0 -s sno1.yaml -t sno2.yaml"

  echo "Can set the diff compare mode to adjust the output of the comparison result:"
  echo "    export DIFF_OPTS=-y"
  echo "    export DIFF_OPTS=\"--suppress-common-lines -W \$(( \$(tput cols) - 2 )) --color -y\""
  echo "    export DIFF_OPTS=--color"
  echo "The default DIFF_OPTS is: \"-W \$(( \$(tput cols) - 2 )) --color -y\""
  echo
  echo "Make sure the server you run the script has the access with oc commands to the 2 clusters."
}

compare_cluster_scoped_resources(){
  crd=$1
  name=$2
  jsonpath=$3

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

  echo "Diff $crd:$name: $DIFF $source_file $target_file"
  echo ------------------------------------------------------------------------------------------------
  $DIFF "$source_file" "$target_file"
  echo ------------------------------------------------------------------------------------------------

}

compare_namespaced_scoped_resources(){
  ns=$1
  crd=$2
  name=$3
  jsonpath=$4

  source_file="source-$ns-$crd-$name.yaml"
  target_file="target-$ns-$crd-$name.yaml"

  if [ -n "$name" ]; then
    source_file="source-$ns-$crd-$name.yaml"
    target_file="target-$ns-$crd-$name.yaml"
  else
    source_file="source-$ns-$crd.yaml"
    target_file="target-$ns-$crd.yaml"
  fi

  if [ -z "$name" ]; then
    $oc1 get -n "$ns" "$crd" -o yaml |yq ".items[0]" > "$source_file"
    $oc2 get -n "$ns" "$crd" -o yaml |yq ".items[0]" > "$target_file"
  else
    if [ -n "$jsonpath" ]; then
      $oc1 get -n "$ns" "$crd" "$name" -o yaml | yq "$jsonpath" > "$source_file"
      $oc2 get -n "$ns" "$crd" "$name" -o yaml | yq "$jsonpath" > "$target_file"
    else
      $oc1 get -n "$ns" "$crd" "$name" -o yaml > "$source_file"
      $oc2 get -n "$ns" "$crd" "$name" -o yaml > "$target_file"
    fi
  fi

  yq -i 'del(.status)|.metadata |= with_entries(select(.key == "name" or .key == "namespace"))' "$source_file"
  yq -i 'del(.status)|.metadata |= with_entries(select(.key == "name" or .key == "namespace"))' "$target_file"

  yq -i -P 'sort_keys(..)' "$source_file"
  yq -i -P 'sort_keys(..)' "$target_file"

  echo "Diff $ns/$crd:$name: $DIFF $source_file $target_file"
  echo ------------------------------------------------------------------------------------------------
  $DIFF "$source_file" "$target_file"
  echo ------------------------------------------------------------------------------------------------

}


while getopts "s:t:h" arg; do
  case $arg in
    s)
      echo "Compare cluster source: ${OPTARG}"
      c1=${OPTARG}
      if [ ! -f "$c1" ]; then
        echo "file $c1 not exist, please check"
        exit -1
      fi
      ;;
    t)
      echo "Compare cluster target: ${OPTARG}"
      c2=${OPTARG}
      if [ ! -f "$c2" ]; then
        echo "file $c2 not exist, please check"
        exit -1
      fi
      ;;
    h | *) # Display help.
      usage
      exit 0
      ;;
  esac
done

oc1="oc --kubeconfig=$c1"
oc2="oc --kubeconfig=$c2"

if [ -n "$DIFF_OPTS" ]; then
  DIFF="diff $DIFF_OPTS"
else
  DIFF="diff -W $(( $(tput cols) - 2 )) --color -y $source_file $target_file"
fi


echo "Compare cluster-scoped resources:"
echo
while read crd name jsonpath; do
  compare_cluster_scoped_resources "$crd" "$name" "$jsonpath"
  echo
done < <(printf '%s\n' "${cluster_scoped_resources[@]}")

while read ns crd name jsonpath; do
  echo "Compare namespace-scoped resources"
  compare_namespaced_scoped_resources $ns $crd $name $jsonpath
  echo
done < <(printf '%s\n' "${namespaced_resources[@]}")

