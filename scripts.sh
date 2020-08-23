#!/usr/bin/env bash
set -o errexit -o pipefail -o nounset

write_script () {
  cat "$(pwd)/scripts/${1}" >> "${output_path}"
}

# Compile style sheets
compile_scripts () {
  scripts="$(yq read "${config_name}" --tojson | jq ".pages.${1}.scripts[]?" | tr -d \" | tr '\n' ',')"
  
  if [ ! "${scripts}" == "" ]; then
    echo "<script>" >> "${output_path}"
    for_each write_script "${scripts}"
    echo "</script>" >> "${output_path}"
  fi
}
