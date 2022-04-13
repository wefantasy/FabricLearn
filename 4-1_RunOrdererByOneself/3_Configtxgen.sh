#!/bin/bash -eu
docker-compose -f $LOCAL_ROOT_PATH/compose/docker-compose.yaml up -d peer1.soft.ifantasy.net peer1.web.ifantasy.net peer1.hard.ifantasy.net 
docker-compose -f $LOCAL_ROOT_PATH/compose/docker-compose.yaml up -d orderer1.soft.ifantasy.net orderer1.web.ifantasy.net orderer1.hard.ifantasy.net
sleep 5

configtxgen -profile OrgsChannel -outputCreateChannelTx $LOCAL_ROOT_PATH/data/testchannel.tx -channelID testchannel
configtxgen -profile OrgsChannel -outputBlock $LOCAL_ROOT_PATH/data/testchannel.block -channelID testchannel

cp $LOCAL_ROOT_PATH/data/testchannel.block $LOCAL_CA_PATH/soft.ifantasy.net/assets/
cp $LOCAL_ROOT_PATH/data/testchannel.block $LOCAL_CA_PATH/web.ifantasy.net/assets/
cp $LOCAL_ROOT_PATH/data/testchannel.block $LOCAL_CA_PATH/hard.ifantasy.net/assets/

source envpeer1soft
osnadmin channel list -o orderer1.soft.ifantasy.net:8252 --ca-file $ORDERER_CA --client-cert $ORDERER_ADMIN_TLS_SIGN_CERT --client-key $ORDERER_ADMIN_TLS_PRIVATE_KEY
osnadmin channel join -o orderer1.soft.ifantasy.net:8252 --channelID testchannel --config-block $LOCAL_ROOT_PATH/data/testchannel.block --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
osnadmin channel list -o orderer1.soft.ifantasy.net:8252 --ca-file $ORDERER_CA --client-cert $ORDERER_ADMIN_TLS_SIGN_CERT --client-key $ORDERER_ADMIN_TLS_PRIVATE_KEY
source envpeer1web
osnadmin channel list -o orderer1.web.ifantasy.net:8352 --ca-file $ORDERER_CA --client-cert $ORDERER_ADMIN_TLS_SIGN_CERT --client-key $ORDERER_ADMIN_TLS_PRIVATE_KEY
osnadmin channel join -o orderer1.web.ifantasy.net:8352 --channelID testchannel --config-block $LOCAL_ROOT_PATH/data/testchannel.block --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
osnadmin channel list -o orderer1.web.ifantasy.net:8352 --ca-file $ORDERER_CA --client-cert $ORDERER_ADMIN_TLS_SIGN_CERT --client-key $ORDERER_ADMIN_TLS_PRIVATE_KEY
source envpeer1hard
osnadmin channel list -o orderer1.hard.ifantasy.net:8452 --ca-file $ORDERER_CA --client-cert $ORDERER_ADMIN_TLS_SIGN_CERT --client-key $ORDERER_ADMIN_TLS_PRIVATE_KEY
osnadmin channel join -o orderer1.hard.ifantasy.net:8452 --channelID testchannel --config-block $LOCAL_ROOT_PATH/data/testchannel.block --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
osnadmin channel list -o orderer1.hard.ifantasy.net:8452 --ca-file $ORDERER_CA --client-cert $ORDERER_ADMIN_TLS_SIGN_CERT --client-key $ORDERER_ADMIN_TLS_PRIVATE_KEY

source envpeer1soft
peer channel join -b $LOCAL_CA_PATH/soft.ifantasy.net/assets/testchannel.block
peer channel list
source envpeer1web
peer channel join -b $LOCAL_CA_PATH/web.ifantasy.net/assets/testchannel.block
peer channel list
source envpeer1hard
peer channel join -b $LOCAL_CA_PATH/hard.ifantasy.net/assets/testchannel.block
peer channel list