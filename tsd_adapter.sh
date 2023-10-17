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

# New token url...
REPLY=$(curl "https://data.tsd.usit.no/all/auth/instances/token" \
    -X POST \
    -H 'Content-Type: application/json' \
    -d "${TOKEN_STRING}")

hastoken=$(jq 'has("token")'  <<< ${REPLY})

if [[ ! "$hastoken" == "true" ]] ; then
    echo "Token not found: ${REPLY}"
    exit 1
fi

TOKEN=$(jq -r .token <<< ${REPLY})

TSD_GROUP=$(jwtd ${TOKEN} | jq -r .groups[0])
TSD_PROJECT=$(jwtd ${TOKEN} | jq -r .proj)
TSD_PATH=$(jwtd ${TOKEN} | jq -r .path)

echo "XXXXXXXX"
echo "${TOKEN_STRING}"
echo "${TOKEN}"
echo "${TSD_GROUP}"
echo "${TSD_PROJECT}"
echo "${TSD_PATH}"
echo "XXXXXXXX"


curl -X PUT \
    -H 'Accept: application/json' \
    -H "Authorization: Bearer ${TOKEN}" \
    --data-binary "@${INPUTFILE}" \
    -v "https://data.tsd.usit.no/${TSD_PROJECT}/files/stream/${TSD_GROUP}/${TSD_PATH}/${INPUTFILE}"

