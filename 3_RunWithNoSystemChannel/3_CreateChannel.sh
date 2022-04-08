#!/bin/bash -eu
docker-compose -f $LOCAL_ROOT_PATH/compose/docker-compose.yaml up -d peer1.soft.ifantasy.net peer1.web.ifantasy.net orderer1.orderer.ifantasy.net
sleep 5

configtxgen -profile OrgsChannel -outputCreateChannelTx $LOCAL_ROOT_PATH/data/mychannel.tx -channelID mychannel
configtxgen -profile OrgsChannel -outputBlock $LOCAL_ROOT_PATH/data/mychannel.block -channelID mychannel
configtxgen -profile OrgsChannel -outputCreateChannelTx $LOCAL_ROOT_PATH/data/testchannel.tx -channelID testchannel
configtxgen -profile OrgsChannel -outputBlock $LOCAL_ROOT_PATH/data/testchannel.block -channelID testchannel

source envpeer1soft
osnadmin channel list -o orderer1.orderer.ifantasy.net:7152 --ca-file $ORDERER_CA --client-cert $ORDERER_ADMIN_TLS_SIGN_CERT --client-key $ORDERER_ADMIN_TLS_PRIVATE_KEY
# error: Get "https://orderer1.orderer.ifantasy.net:7151/participation/v1/channels": net/http: HTTP/1.x transport connection broken: malformed HTTP response "\x00\x00\x06\x04\x00\x00\x00\x00\x00\x00\x05\x00\x00@\x00"
# 要使用 admin 端口和证书
osnadmin channel join --channelID mychannel --config-block $LOCAL_ROOT_PATH/data/mychannel.block -o orderer1.orderer.ifantasy.net:7152 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
# osnadmin: error: parsing arguments: failed to retrieve channel id - block is empty. Try --help
# 参数指定为 -outputBlock 输出的创世区块
osnadmin channel join --channelID testchannel --config-block $LOCAL_ROOT_PATH/data/testchannel.block -o orderer1.orderer.ifantasy.net:7152 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
osnadmin channel list -o orderer1.orderer.ifantasy.net:7152 --ca-file $ORDERER_CA --client-cert $ORDERER_ADMIN_TLS_SIGN_CERT --client-key $ORDERER_ADMIN_TLS_PRIVATE_KEY

cp $LOCAL_ROOT_PATH/data/mychannel.block $LOCAL_CA_PATH/soft.ifantasy.net/assets/
cp $LOCAL_ROOT_PATH/data/mychannel.block $LOCAL_CA_PATH/web.ifantasy.net/assets/
cp $LOCAL_ROOT_PATH/data/testchannel.block $LOCAL_CA_PATH/soft.ifantasy.net/assets/
cp $LOCAL_ROOT_PATH/data/testchannel.block $LOCAL_CA_PATH/web.ifantasy.net/assets/

source envpeer1soft
peer channel join -b $LOCAL_CA_PATH/soft.ifantasy.net/assets/mychannel.block
peer channel join -b $LOCAL_CA_PATH/soft.ifantasy.net/assets/testchannel.block
peer channel list
source envpeer1web
peer channel join -b $LOCAL_CA_PATH/web.ifantasy.net/assets/mychannel.block
peer channel join -b $LOCAL_CA_PATH/web.ifantasy.net/assets/testchannel.block
peer channel list