#!/bin/bash

ORG=soft
P0PORT=7251
CAPORT=7250
cryptoPath=$LOCAL_CA_PATH/soft.ifantasy.net
PEERPEM=$cryptoPath/assets/tls-ca-cert.pem
CAPEM=$cryptoPath/assets/ca-cert.pem

PP="`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $PEERPEM`"
CP="`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $CAPEM`"

sed -e "s/\${ORG}/$ORG/" \
        -e "s/\${P0PORT}/$P0PORT/" \
        -e "s/\${CAPORT}/$CAPORT/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        config/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'  > connection-soft.yaml
