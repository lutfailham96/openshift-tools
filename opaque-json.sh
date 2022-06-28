#!/bin/bash

function opaque_to_json() {
  input="$(cat "${1}" | sed ':a;N;$!ba;s/>-\n    //g' | sed 's/: /:/g')"
  last_input_key=$(echo "${input}" | tail -n 1 | sed 's/  //g' | sed  's/: /:/g' | cut -f 1 -d ':')
  echo "{"
  while IFS= read -r line
  do
    key=$(echo $line | cut -f 1 -d ':')
    value=$(echo $line | cut -f 2 -d ':' | base64 -d)
    out=$(echo "  \"${key}\": \"${value}\"",)
    if [[ "${key}" == "${last_input_key}" ]]; then
      out=$(echo "  \"${key}\": \"${value}\"")
    fi
    echo "${out}"
  done < <(echo "${input}")
  echo "}"
}

opaque_to_json "${1}"
