#!/bin/bash

basedir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

usage(){
  echo "Usage: $0 source-must-gather-dir> <target-must-gather-dir"
  echo "This script will compare resources collected in the two must-gather folders"

  echo "Example: $0 must-gather1 muster-gather2"

  echo "Can set the diff compare mode to adjust the output of the comparison result:"
  echo "    export DIFF_OPTS=-y"
  echo "    export DIFF_OPTS=\"--suppress-common-lines -W \$(( \$(tput cols) - 2 )) --color -y\""
  echo "    export DIFF_OPTS=--color"
  echo "The default DIFF_OPTS is: \"-W \$(( \$(tput cols) - 2 )) --color -y\""
  echo
  echo "Make sure you run collection-scripts/gather towards the 2 clusters you want to compare first."
}

info(){
  printf  $(tput setaf 2)"%-148s %-10s %-10s %-50s"$(tput sgr0)"\n" "$@"
}

title(){
  printf  $(tput setaf 4)"%-148s %-10s %-10s %-50s"$(tput sgr0)"\n" "$@"
}

warn(){
  printf  $(tput setaf 3)"%-148s %-10s %-10s %-50s"$(tput sgr0)"\n" "$@"
}

red(){
  printf  $(tput setaf 1)"%-148s %-10s %-10s %-50s"$(tput sgr0)"\n" "$@"
}


FILTER_FIELDS='
del(.metadata.creationTimestamp) |
del(.metadata.resourceVersion) |
del(.metadata.annotations) |
del(.metadata.uid) |
del(.metadata.generation) |
del(.status) |
del(.metadata.ownerReferences) |
del(.spec.clusterID) |
del(.metadata.managedFields)
'

random_name(){
  cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1
}

compare(){
  echo "Compare all resources between $source_dir and $target_dir, following is the report:"
  echo
  report_dir="$basedir/cluster-diff-$(date +%Y%m%d%H%M%S)"
  mkdir -p "${report_dir}"

  local tmp_dir=$(mktemp -d)
  #trap 'rm -rf "${tmp_dir}"' EXIT

  title "File" "S" "T" "Diff"
  find "$source_dir" "$target_dir" \( -wholename '*cluster-scoped-resources/*.yaml' -o -wholename '*namespaces/*.yaml' \) -printf "%P\n" | sort | uniq | while IFS= read -r file; do
    rel_path="${file#*cluster-scoped-resources/}"
    rel_path="${rel_path#*namespaces/}"

    # Determine resource type path for cross-check
    if [[ "$file" == *"cluster-scoped-resources"* ]]; then
      rel_path="cluster-scoped-resources/$rel_path"
    else
      rel_path="namespaces/$rel_path"
    fi

    source_root_dir="$(find $source_dir -type d -name cluster-scoped-resources)"
    source_root_dir="${source_root_dir/cluster-scoped-resources//}"
    target_root_dir="$(find $target_dir -type d -name cluster-scoped-resources)"
    target_root_dir="${target_root_dir/cluster-scoped-resources//}"

    source_cr="$source_root_dir/$rel_path"
    target_cr="$target_root_dir/$rel_path"

    exists_source="yes"
    exists_target="yes"

    if [ ! -f "$source_cr" ]; then
      red "$rel_path" "No" "Yes" "$target_dir/"
      exists_source="no"
    fi

    if [ ! -f "$target_cr" ]; then
      red "$rel_path" "Yes" "No" "$source_dir/"
      exists_target="no"
    fi

    if [ "$exists_source" = "yes" ] && [ "$exists_target" = "yes" ]; then
      cr_random=$(random_name)
      tfile_source="${tmp_dir}/${cr_random}-source.yaml"
      tfile_target="${tmp_dir}/${cr_random}-target.yaml"

      yq eval "${FILTER_FIELDS}" "${source_cr}" | yq eval --prettyPrint > "${tfile_source}" 2>/dev/null;
      yq eval "${FILTER_FIELDS}" "${target_cr}" | yq eval --prettyPrint > "${tfile_target}" 2>/dev/null;

      if ! diff -q "${tfile_source}" "${tfile_target}" >/dev/null; then
        diff_file="${report_dir}/${cr_random}.diff"
        warn "$rel_path" "Yes" "Yes" ${diff_file}
        $DIFF "${tfile_source}" "${tfile_target}" > "${diff_file}" 2>&1 || true
      else
        info "$rel_path" "Yes" "Yes" "NA"
      fi
    fi

  done
}

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <source-must-gather-dir> <target-must-gather-dir>"
  exit 1
fi

if [ -n "$DIFF_OPTS" ]; then
  DIFF="diff $DIFF_OPTS"
else
  DIFF="diff -W $(( $(tput cols) - 2 )) --color -y $source_file $target_file"
fi

source_dir=$1
target_dir=$2

compare
