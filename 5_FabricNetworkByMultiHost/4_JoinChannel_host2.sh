#!/bin/bash -eu
docker-compose -f $LOCAL_ROOT_PATH/compose/docker-compose.yaml up -d web.ifantasy.net peer1.web.ifantasy.net hard.ifantasy.net peer1.hard.ifantasy.net 
docker-compose -f $LOCAL_ROOT_PATH/compose/docker-compose.yaml up -d orderer3.council.ifantasy.net
sleep 5

source envpeer1web
export ORDERER_ADMIN_TLS_SIGN_CERT=$LOCAL_CA_PATH/council.ifantasy.net/registers/orderer3/tls-msp/signcerts/cert.pem
export ORDERER_ADMIN_TLS_PRIVATE_KEY=$LOCAL_CA_PATH/council.ifantasy.net/registers/orderer3/tls-msp/keystore/key.pem
osnadmin channel join -o orderer3.council.ifantasy.net:7058 --channelID testchannel --config-block $LOCAL_ROOT_PATH/data/testchannel.block --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
osnadmin channel list -o orderer3.council.ifantasy.net:7058 --ca-file $ORDERER_CA --client-cert $ORDERER_ADMIN_TLS_SIGN_CERT --client-key $ORDERER_ADMIN_TLS_PRIVATE_KEY

source envpeer1web
peer channel join -b $LOCAL_CA_PATH/web.ifantasy.net/assets/testchannel.block
peer channel list
source envpeer1hard
peer channel join -b $LOCAL_CA_PATH/hard.ifantasy.net/assets/testchannel.block
peer channel list