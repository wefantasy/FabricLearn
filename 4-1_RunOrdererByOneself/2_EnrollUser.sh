#!/bin/bash -eu
echo "Preparation============================="
mkdir -p $LOCAL_CA_PATH/soft.ifantasy.net/assets
cp $LOCAL_CA_PATH/soft.ifantasy.net/ca/crypto/ca-cert.pem $LOCAL_CA_PATH/soft.ifantasy.net/assets/ca-cert.pem
cp $LOCAL_CA_PATH/council.ifantasy.net/ca/crypto/ca-cert.pem $LOCAL_CA_PATH/soft.ifantasy.net/assets/tls-ca-cert.pem

mkdir -p $LOCAL_CA_PATH/web.ifantasy.net/assets 
cp $LOCAL_CA_PATH/web.ifantasy.net/ca/crypto/ca-cert.pem $LOCAL_CA_PATH/web.ifantasy.net/assets/ca-cert.pem
cp $LOCAL_CA_PATH/council.ifantasy.net/ca/crypto/ca-cert.pem $LOCAL_CA_PATH/web.ifantasy.net/assets/tls-ca-cert.pem

mkdir -p $LOCAL_CA_PATH/hard.ifantasy.net/assets
cp $LOCAL_CA_PATH/hard.ifantasy.net/ca/crypto/ca-cert.pem $LOCAL_CA_PATH/hard.ifantasy.net/assets/ca-cert.pem
cp $LOCAL_CA_PATH/council.ifantasy.net/ca/crypto/ca-cert.pem $LOCAL_CA_PATH/hard.ifantasy.net/assets/tls-ca-cert.pem
echo "Preparation============================="

echo "Start Soft============================="
echo "Enroll Admin"
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/soft.ifantasy.net/registers/admin1
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/soft.ifantasy.net/assets/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin1:admin1@soft.ifantasy.net:7250
mkdir -p $LOCAL_CA_PATH/soft.ifantasy.net/registers/admin1/msp/admincerts
cp $LOCAL_CA_PATH/soft.ifantasy.net/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/soft.ifantasy.net/registers/admin1/msp/admincerts/cert.pem

echo "Enroll Peer1"
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/soft.ifantasy.net/registers/peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/soft.ifantasy.net/assets/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://peer1:peer1@soft.ifantasy.net:7250
# for TLS
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/soft.ifantasy.net/assets/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer1soft:peer1soft@council.ifantasy.net:7050 --enrollment.profile tls --csr.hosts peer1.soft.ifantasy.net
cp $LOCAL_CA_PATH/soft.ifantasy.net/registers/peer1/tls-msp/keystore/*_sk $LOCAL_CA_PATH/soft.ifantasy.net/registers/peer1/tls-msp/keystore/key.pem
mkdir -p $LOCAL_CA_PATH/soft.ifantasy.net/registers/peer1/msp/admincerts
cp $LOCAL_CA_PATH/soft.ifantasy.net/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/soft.ifantasy.net/registers/peer1/msp/admincerts/cert.pem

echo "Enroll Orderer1"
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/soft.ifantasy.net/registers/orderer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/soft.ifantasy.net/assets/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://orderer1:orderer1@soft.ifantasy.net:7250
# for TLS
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/soft.ifantasy.net/assets/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer1soft:orderer1soft@council.ifantasy.net:7050 --enrollment.profile tls --csr.hosts orderer1.soft.ifantasy.net
cp $LOCAL_CA_PATH/soft.ifantasy.net/registers/orderer1/tls-msp/keystore/*_sk $LOCAL_CA_PATH/soft.ifantasy.net/registers/orderer1/tls-msp/keystore/key.pem
mkdir -p $LOCAL_CA_PATH/soft.ifantasy.net/registers/orderer1/msp/admincerts
cp $LOCAL_CA_PATH/soft.ifantasy.net/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/soft.ifantasy.net/registers/orderer1/msp/admincerts/cert.pem

mkdir -p $LOCAL_CA_PATH/soft.ifantasy.net/msp/admincerts
mkdir -p $LOCAL_CA_PATH/soft.ifantasy.net/msp/cacerts
mkdir -p $LOCAL_CA_PATH/soft.ifantasy.net/msp/tlscacerts
mkdir -p $LOCAL_CA_PATH/soft.ifantasy.net/msp/users
cp $LOCAL_CA_PATH/soft.ifantasy.net/assets/ca-cert.pem $LOCAL_CA_PATH/soft.ifantasy.net/msp/cacerts/
cp $LOCAL_CA_PATH/soft.ifantasy.net/assets/tls-ca-cert.pem $LOCAL_CA_PATH/soft.ifantasy.net/msp/tlscacerts/
cp $LOCAL_CA_PATH/soft.ifantasy.net/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/soft.ifantasy.net/msp/admincerts/cert.pem
cp $LOCAL_ROOT_PATH/config/config-msp.yaml $LOCAL_CA_PATH/soft.ifantasy.net/msp/config.yaml
echo "End Soft============================="

echo "Start Web============================="
echo "Enroll Admin"
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/web.ifantasy.net/registers/admin1
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/web.ifantasy.net/assets/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin1:admin1@web.ifantasy.net:7350
mkdir -p $LOCAL_CA_PATH/web.ifantasy.net/registers/admin1/msp/admincerts
cp $LOCAL_CA_PATH/web.ifantasy.net/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/web.ifantasy.net/registers/admin1/msp/admincerts/cert.pem

echo "Enroll Peer1"
# for identity
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/web.ifantasy.net/registers/peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/web.ifantasy.net/assets/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://peer1:peer1@web.ifantasy.net:7350
# for TLS
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/web.ifantasy.net/assets/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer1web:peer1web@council.ifantasy.net:7050 --enrollment.profile tls --csr.hosts peer1.web.ifantasy.net
cp $LOCAL_CA_PATH/web.ifantasy.net/registers/peer1/tls-msp/keystore/*_sk $LOCAL_CA_PATH/web.ifantasy.net/registers/peer1/tls-msp/keystore/key.pem
mkdir -p $LOCAL_CA_PATH/web.ifantasy.net/registers/peer1/msp/admincerts
cp $LOCAL_CA_PATH/web.ifantasy.net/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/web.ifantasy.net/registers/peer1/msp/admincerts/cert.pem

echo "Enroll Orderer1"
# for identity
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/web.ifantasy.net/registers/orderer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/web.ifantasy.net/assets/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://orderer1:orderer1@web.ifantasy.net:7350
mkdir -p $LOCAL_CA_PATH/web.ifantasy.net/registers/orderer1/msp/admincerts
cp $LOCAL_CA_PATH/web.ifantasy.net/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/web.ifantasy.net/registers/orderer1/msp/admincerts/cert.pem
# for TLS
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/web.ifantasy.net/assets/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer1web:orderer1web@council.ifantasy.net:7050 --enrollment.profile tls --csr.hosts orderer1.web.ifantasy.net
cp $LOCAL_CA_PATH/web.ifantasy.net/registers/orderer1/tls-msp/keystore/*_sk $LOCAL_CA_PATH/web.ifantasy.net/registers/orderer1/tls-msp/keystore/key.pem

mkdir -p $LOCAL_CA_PATH/web.ifantasy.net/msp/admincerts
mkdir -p $LOCAL_CA_PATH/web.ifantasy.net/msp/cacerts
mkdir -p $LOCAL_CA_PATH/web.ifantasy.net/msp/tlscacerts
mkdir -p $LOCAL_CA_PATH/web.ifantasy.net/msp/users
cp $LOCAL_CA_PATH/web.ifantasy.net/assets/ca-cert.pem $LOCAL_CA_PATH/web.ifantasy.net/msp/cacerts/
cp $LOCAL_CA_PATH/web.ifantasy.net/assets/tls-ca-cert.pem $LOCAL_CA_PATH/web.ifantasy.net/msp/tlscacerts/
cp $LOCAL_CA_PATH/web.ifantasy.net/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/web.ifantasy.net/msp/admincerts/cert.pem
cp $LOCAL_ROOT_PATH/config/config-msp.yaml $LOCAL_CA_PATH/web.ifantasy.net/msp/config.yaml
echo "End Web============================="

echo "Start Hard============================="
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

echo "Enroll Orderer1"
# for identity
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/hard.ifantasy.net/registers/orderer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/hard.ifantasy.net/assets/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://orderer1:orderer1@hard.ifantasy.net:7450
mkdir -p $LOCAL_CA_PATH/hard.ifantasy.net/registers/orderer1/msp/admincerts
cp $LOCAL_CA_PATH/hard.ifantasy.net/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/hard.ifantasy.net/registers/orderer1/msp/admincerts/cert.pem
# for TLS
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/hard.ifantasy.net/assets/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer1hard:orderer1hard@council.ifantasy.net:7050 --enrollment.profile tls --csr.hosts orderer1.hard.ifantasy.net
cp $LOCAL_CA_PATH/hard.ifantasy.net/registers/orderer1/tls-msp/keystore/*_sk $LOCAL_CA_PATH/hard.ifantasy.net/registers/orderer1/tls-msp/keystore/key.pem

mkdir -p $LOCAL_CA_PATH/hard.ifantasy.net/msp/admincerts
mkdir -p $LOCAL_CA_PATH/hard.ifantasy.net/msp/cacerts
mkdir -p $LOCAL_CA_PATH/hard.ifantasy.net/msp/tlscacerts
mkdir -p $LOCAL_CA_PATH/hard.ifantasy.net/msp/users
cp $LOCAL_CA_PATH/hard.ifantasy.net/assets/ca-cert.pem $LOCAL_CA_PATH/hard.ifantasy.net/msp/cacerts/
cp $LOCAL_CA_PATH/hard.ifantasy.net/assets/tls-ca-cert.pem $LOCAL_CA_PATH/hard.ifantasy.net/msp/tlscacerts/
cp $LOCAL_CA_PATH/hard.ifantasy.net/registers/admin1/msp/signcerts/cert.pem $LOCAL_CA_PATH/hard.ifantasy.net/msp/admincerts/cert.pem
cp $LOCAL_ROOT_PATH/config/config-msp.yaml $LOCAL_CA_PATH/hard.ifantasy.net/msp/config.yaml
echo "End Hard============================="