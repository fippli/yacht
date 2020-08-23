#!/usr/bin/env bash
set -o errexit -o pipefail -o nounset

##
# Trying to make something like a for_each funciton
# Usage:
# for_each <function> <comma-separated-array> ...<args-passed-to-function>
##
for_each () {
  args=( "$@" )
  IFS=',' read -ra array <<< "$2"

  for item in "${array[@]}"; do
    $1 "$item" "${args[@]:2}"
  done
}
