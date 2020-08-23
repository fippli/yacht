#!/usr/bin/env bash
set -o errexit -o pipefail -o nounset

html_start () {
cat > "${1}" <<EOF
<!DOCTYPE HTML>
<html>
EOF
}

head () {
cat >> "${1}" <<EOF
<head>
<meta />
</head>
EOF
}

html_end () {
cat >> "${1}" <<EOF
</html>
EOF
}

compile () {
  file="$(yq read "${config_name}" --tojson | jq ".pages.${1}.name" | tr -d \")"
  html_start "$(get_output_path)/${file}"
  head "$(get_output_path)/${file}"
  body "${1}" "$(get_output_path)/${file}"
  html_end "$(get_output_path)/${file}"
}
