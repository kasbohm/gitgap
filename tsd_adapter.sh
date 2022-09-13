#!/bin/bash
INPUTFILE=$1

# Decode jwt
jwtd() {
    if [[ -x $(command -v jq) ]]; then
         jq -R 'split(".") | .[1] | @base64d | fromjson' <<< "${1}"
    fi
}

TOKEN_STRING=$( jq -n \
                  --arg id "$TSD_LINKID" \
                  --arg sec "$TSD_SECRET" \
                  '{id: $id, secret_challenge: $sec}' )

TOKEN=$(curl "https://data.tsd.usit.no/capability_token/" \
    -X POST \
    -H 'Content-Type: application/json' \
    -d "${TOKEN_STRING}" | jq -r .token)


TSD_GROUP=$(jwtd ${TOKEN} | jq -r .groups[0])
TSD_PROJECT=$(jwtd ${TOKEN} | jq -r .proj)
TSD_PATH=$(jwtd ${TOKEN} | jq -r .path)

# echo "TOKEN: ${TOKEN}"
# echo "TSD_GROUP: ${TSD_GROUP}"
# echo "TSD_PROJECT: ${TSD_PROJECT}"
# echo "TSD_PATH: ${TSD_PATH}"

curl -X PUT \
    -H 'Accept: application/json' \
    -H "Authorization: Bearer ${TOKEN}" \
    --data-binary "@${INPUTFILE}" \
    -v "https://data.tsd.usit.no/v1/${TSD_PROJECT}/files/stream/${TSD_GROUP}/${TSD_PATH}/${INPUTFILE}"

