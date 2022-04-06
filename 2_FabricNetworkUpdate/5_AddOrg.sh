#!/bin/bash -eu

docker-compose -f $LOCAL_ROOT_PATH/compose/docker-compose.yaml up -d hard.ifantasy.net
sleep 5

echo "Working on tls"
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/council.ifantasy.net/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/council.ifantasy.net/ca/admin
fabric-ca-client enroll -d -u https://ca-admin:ca-adminpw@council.ifantasy.net:7050
fabric-ca-client register -d --id.name peer1hard --id.secret peer1hard --id.type orderer -u https://council.ifantasy.net:7050
echo "Working on hard"
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/hard.ifantasy.net/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/hard.ifantasy.net/ca/admin
fabric-ca-client enroll -d -u https://ca-admin:ca-adminpw@hard.ifantasy.net:7450
fabric-ca-client register -d --id.name peer1 --id.secret peer1 --id.type peer -u https://hard.ifantasy.net:7450
fabric-ca-client register -d --id.name admin1 --id.secret admin1 --id.type admin -u https://hard.ifantasy.net:7450

echo "Preparation============================="
mkdir -p $LOCAL_CA_PATH/hard.ifantasy.net/assets
cp $LOCAL_CA_PATH/hard.ifantasy.net/ca/crypto/ca-cert.pem $LOCAL_CA_PATH/hard.ifantasy.net/assets/ca-cert.pem
cp $LOCAL_CA_PATH/council.ifantasy.net/ca/crypto/ca-cert.pem $LOCAL_CA_PATH/hard.ifantasy.net/assets/tls-ca-cert.pem
echo "Preparation============================="
echo "Enroll Admin"
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/hard.ifantasy.net/registers/admin1
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/hard.ifantasy.net/assets/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin1:admin1@hard.ifantasy.net:7450
mkdir -p $LOCAL_CA_PATH/hard.ifantasy.net/registers/admin1/msp/admincerts
cp $LOCAL_CA_PATH/hard.ifantasy.net/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/hard.ifantasy.net/registers/admin1/msp/admincerts/cert.pem
echo "Enroll Peer1"
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/hard.ifantasy.net/registers/peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/hard.ifantasy.net/assets/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://peer1:peer1@hard.ifantasy.net:7450
# for TLS
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/hard.ifantasy.net/assets/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer1hard:peer1hard@council.ifantasy.net:7050 --enrollment.profile tls --csr.hosts peer1.hard.ifantasy.net
cp $LOCAL_CA_PATH/hard.ifantasy.net/registers/peer1/tls-msp/keystore/*_sk $LOCAL_CA_PATH/hard.ifantasy.net/registers/peer1/tls-msp/keystore/key.pem
mkdir -p $LOCAL_CA_PATH/hard.ifantasy.net/registers/peer1/msp/admincerts
cp $LOCAL_CA_PATH/hard.ifantasy.net/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/hard.ifantasy.net/registers/peer1/msp/admincerts/cert.pem
mkdir -p $LOCAL_CA_PATH/hard.ifantasy.net/msp/admincerts
mkdir -p $LOCAL_CA_PATH/hard.ifantasy.net/msp/cacerts
mkdir -p $LOCAL_CA_PATH/hard.ifantasy.net/msp/tlscacerts
mkdir -p $LOCAL_CA_PATH/hard.ifantasy.net/msp/users
cp $LOCAL_CA_PATH/hard.ifantasy.net/assets/ca-cert.pem $LOCAL_CA_PATH/hard.ifantasy.net/msp/cacerts/
cp $LOCAL_CA_PATH/hard.ifantasy.net/assets/tls-ca-cert.pem $LOCAL_CA_PATH/hard.ifantasy.net/msp/tlscacerts/
cp $LOCAL_CA_PATH/hard.ifantasy.net/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/hard.ifantasy.net/msp/admincerts/cert.pem
cp $LOCAL_ROOT_PATH/config/config-msp.yaml $LOCAL_CA_PATH/hard.ifantasy.net/msp/config.yaml
echo "End hard============================="

docker-compose -f $LOCAL_ROOT_PATH/compose/docker-compose.yaml up -d peer1.hard.ifantasy.net
sleep 5

source envpeer1soft
peer channel fetch config update/config_block.pb -o orderer1.orderer.ifantasy.net:7151 -c mychannel --tls --cafile $ORDERER_CA

configtxlator proto_decode --input update/config_block.pb --type common.Block | jq .data.data[0].payload.data.config > update/config.json

configtxgen -printOrg hardMSP > $LOCAL_CA_PATH/hard.ifantasy.net/hard.json

jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"hardMSP":.[1]}}}}}' update/config.json $LOCAL_CA_PATH/hard.ifantasy.net/hard.json > update/modified_config.json

configtxlator proto_encode --input update/config.json --type common.Config --output update/config.pb

configtxlator proto_encode --input update/modified_config.json --type common.Config --output update/modified_config.pb

configtxlator compute_update --channel_id mychannel --original update/config.pb --updated update/modified_config.pb --output update/hard_update.pb

configtxlator proto_decode --input update/hard_update.pb --type common.ConfigUpdate | jq . > update/hard_update.json

echo '{"payload":{"header":{"channel_header":{"channel_id":"mychannel", "type":2}},"data":{"config_update":'$(cat update/hard_update.json)'}}}' | jq . > update/hard_update_in_envelope.json

configtxlator proto_encode --input update/hard_update_in_envelope.json --type common.Envelope --output update/hard_update_in_envelope.pb

source envpeer1soft
peer channel signconfigtx -f update/hard_update_in_envelope.pb

source envpeer1web
peer channel update -f update/hard_update_in_envelope.pb -c mychannel -o orderer1.orderer.ifantasy.net:7151 --tls --cafile $ORDERER_CA

source envpeer1hard
peer channel fetch 0 mychannel.block -o orderer1.orderer.ifantasy.net:7151 -c mychannel --tls --cafile $ORDERER_CA

peer channel join -b mychannel.block