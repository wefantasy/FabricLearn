#!/bin/bash -eu

export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/council.ifantasy.net/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/council.ifantasy.net/ca/admin
fabric-ca-client register -d --id.name peer2soft --id.secret peer2soft --id.type peer -u https://council.ifantasy.net:7050

export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/soft.ifantasy.net/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/soft.ifantasy.net/ca/admin
fabric-ca-client register -d --id.name peer2 --id.secret peer2 --id.type peer -u https://soft.ifantasy.net:7250

echo "Enroll Peer2"
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/soft.ifantasy.net/registers/peer2
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/soft.ifantasy.net/assets/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://peer2:peer2@soft.ifantasy.net:7250
# for TLS
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/soft.ifantasy.net/assets/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer2soft:peer2soft@council.ifantasy.net:7050 --enrollment.profile tls --csr.hosts peer2.soft.ifantasy.net
cp $LOCAL_CA_PATH/soft.ifantasy.net/registers/peer2/tls-msp/keystore/*_sk $LOCAL_CA_PATH/soft.ifantasy.net/registers/peer2/tls-msp/keystore/key.pem
mkdir -p $LOCAL_CA_PATH/soft.ifantasy.net/registers/peer2/msp/admincerts
cp $LOCAL_CA_PATH/soft.ifantasy.net/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/soft.ifantasy.net/registers/peer2/msp/admincerts/cert.pem

docker-compose -f $LOCAL_ROOT_PATH/compose/update-peer.yaml up -d peer2.soft.ifantasy.net
# echo "127.0.0.1       peer2.soft.ifantasy.net" >> /etc/hosts

peer channel fetch 0 mychannel.block -o orderer1.orderer.ifantasy.net:7151 -c mychannel --tls --cafile $ORDERER_CA
source envpeer2soft
peer channel join -b mychannel.block
peer channel getinfo -c mychannel

peer lifecycle chaincode install basic.tar.gz
peer channel getinfo -c mychannel


