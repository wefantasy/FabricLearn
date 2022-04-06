#!/bin/bash -eu

source envpeer1web
peer channel fetch config update/config_block.pb -o orderer1.orderer.ifantasy.net:7151 -c mychannel --tls --cafile $ORDERER_CA

configtxlator proto_decode --input update/config_block.pb --type common.Block | jq .data.data[0].payload.data.config > update/config.json

jq 'del(.channel_group.groups.Application.groups.softMSP)'  update/config.json > update/modified_config.json

configtxlator proto_encode --input update/config.json --type common.Config --output update/config.pb

configtxlator proto_encode --input update/modified_config.json --type common.Config --output update/modified_config.pb

configtxlator compute_update --channel_id mychannel --original update/config.pb --updated update/modified_config.pb --output update/soft_update.pb

configtxlator proto_decode --input update/soft_update.pb --type common.ConfigUpdate | jq . > update/soft_update.json

echo '{"payload":{"header":{"channel_header":{"channel_id":"mychannel", "type":2}},"data":{"config_update":'$(cat update/soft_update.json)'}}}' | jq . > update/soft_update_in_envelope.json

configtxlator proto_encode --input update/soft_update_in_envelope.json --type common.Envelope --output update/soft_update_in_envelope.pb

source envpeer1web
peer channel signconfigtx -f update/soft_update_in_envelope.pb

source envpeer1hard
peer channel update -f update/soft_update_in_envelope.pb -c mychannel -o orderer1.orderer.ifantasy.net:7151 --tls --cafile $ORDERER_CA
