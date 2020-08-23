#!/usr/bin/env bash
set -o errexit -o pipefail -o nounset

scripts () {
cat >> "${output_path}" <<EOF
<script src=""></script>
EOF
}

##
# 1. page name
# 2. layout name
# 3. variable name
get_variable_value () {
  yq read "${config_name}" --tojson | jq ".pages.${1}.layout.${2}.variables.${3}" | tr -d \"
}

##
# 1. page name
# 2. layout name
get_template_file () {
  yq read "${config_name}" --tojson | jq ".pages.${1}.layout.${2}.template" | tr -d \"
}

# 1. Variable 
# 2. Template name
# 3. Page name
replace_variable () {
  value="$(get_variable_value "${2}" "${3}" "${4}")"
  echo "${1//"{{${4}}}"/${value}}"
}

##
# Recursively replace all variables in 
# the template
# 1. Template
# 2. Layout name
# 3. Page name
# 4. ...vars
replace_variables () {
  if [[ $# -eq 3 ]]; then
    echo "${1}"
  else
    next_variable="${4}"
    next_content="$(replace_variable "${1}" "${3}" "${2}" "${next_variable}")"
    replace_variables "${next_content}" "${2}" "${3}" "${@:5}"
  fi  
}

# 1. layout name
# 2. page name
write_template () {
  variables="$(yq read "${config_name}" --tojson | jq ".pages.${2}.layout.${1}.variables | keys[]" | tr -d \" | tr '\n' ',' || echo "no variables")"

  if [ "${variables}" == "no variables" ]; then
    get_template_file "${2}" "${1}"
  else
    ## This needs to be done recursively if possible...
    IFS=',' read -ra variable_array <<< "${variables}"
    template_file="$(get_template_file "${2}" "${1}")"
    template="$(<"./templates/${template_file}")"
    parsed_template="$(replace_variables "${template}" "${1}" "${2}" "${variable_array[@]}")"
    echo "${parsed_template}" >> "${output_path}"
  fi

}

get_template () {
  layouts="$(yq read "${config_name}" --tojson | jq ".pages.${1}.layout | keys[]" | tr -d \" | tr '\n' ',')"
  for_each write_template "${layouts}" "${1}"
}

# Compile the body tag
body () {
  output_path="${2}"
  echo "<body>" >> "${output_path}"
  compile_styles "${1}"
  get_template "${1}"
  compile_scripts "${1}"
  echo "</body>" >> "${output_path}"
}
