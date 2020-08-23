#!/usr/bin/env bash
set -o errexit -o pipefail -o nounset

write_style () {
  cat "$(pwd)/styles/${1}" >> "${output_path}"
}

# Compile style sheets
compile_styles () {
  styles="$(yq read "${config_name}" --tojson | jq ".pages.${1}.styles[]?" | tr -d \" | tr '\n' ',')"
  
  if [ ! "${styles}" == "" ]; then
    echo "<style>" >> "${output_path}"
    for_each write_style "${styles}"
    echo "</style>" >> "${output_path}"
  fi
}
