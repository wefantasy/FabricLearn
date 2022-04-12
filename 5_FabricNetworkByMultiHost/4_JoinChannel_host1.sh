#!/bin/bash -eu
docker-compose -f $LOCAL_ROOT_PATH/compose/docker-compose.yaml up -d council.ifantasy.net soft.ifantasy.net peer1.soft.ifantasy.net 
docker-compose -f $LOCAL_ROOT_PATH/compose/docker-compose.yaml up -d orderer1.council.ifantasy.net orderer2.council.ifantasy.net
sleep 5

source envpeer1soft
export ORDERER_ADMIN_TLS_SIGN_CERT=$LOCAL_CA_PATH/council.ifantasy.net/registers/orderer1/tls-msp/signcerts/cert.pem
export ORDERER_ADMIN_TLS_PRIVATE_KEY=$LOCAL_CA_PATH/council.ifantasy.net/registers/orderer1/tls-msp/keystore/key.pem
osnadmin channel join -o orderer1.council.ifantasy.net:7052 --channelID testchannel --config-block $LOCAL_ROOT_PATH/data/testchannel.block --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
osnadmin channel list -o orderer1.council.ifantasy.net:7052 --ca-file $ORDERER_CA --client-cert $ORDERER_ADMIN_TLS_SIGN_CERT --client-key $ORDERER_ADMIN_TLS_PRIVATE_KEY
export ORDERER_ADMIN_TLS_SIGN_CERT=$LOCAL_CA_PATH/council.ifantasy.net/registers/orderer2/tls-msp/signcerts/cert.pem
export ORDERER_ADMIN_TLS_PRIVATE_KEY=$LOCAL_CA_PATH/council.ifantasy.net/registers/orderer2/tls-msp/keystore/key.pem
osnadmin channel join -o orderer2.council.ifantasy.net:7055 --channelID testchannel --config-block $LOCAL_ROOT_PATH/data/testchannel.block --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
osnadmin channel list -o orderer2.council.ifantasy.net:7055 --ca-file $ORDERER_CA --client-cert $ORDERER_ADMIN_TLS_SIGN_CERT --client-key $ORDERER_ADMIN_TLS_PRIVATE_KEY

source envpeer1soft
peer channel join -b $LOCAL_CA_PATH/soft.ifantasy.net/assets/testchannel.block
peer channel list