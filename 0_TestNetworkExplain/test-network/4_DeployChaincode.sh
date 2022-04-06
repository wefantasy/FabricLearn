#!/bin/bash -eu

pushd asset-transfer-basic-go
GO111MODULE=on go mod vendor
popd

# 设置环境变量
export FABRIC_CFG_PATH=$PWD/config/
export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem
export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem
export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem
export PEER0_ORG3_CA=${PWD}/organizations/peerOrganizations/org3.example.com/tlsca/tlsca.org3.example.com-cert.pem
export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

# 重新打包可能会生成新的链码ID，需要修改PACKAGE_ID
# peer lifecycle chaincode package mychaincode.tar.gz --path ./asset-transfer-basic-go --lang golang --label mychaincode_1.0

# ORG1安装链码
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051
peer lifecycle chaincode install mychaincode.tar.gz
# ORG2安装链码
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051
peer lifecycle chaincode install mychaincode.tar.gz

export PACKAGE_ID=mychaincode_1.0:39889cf0623cce2500261b22914a7aa9037a897bc7f6c5b36df7a922f29b05e0

# ORG1查询已安装链码并批准链码
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051
# 查询已安装链码
peer lifecycle chaincode queryinstalled
# 批准链码
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "$ORDERER_CA" --channelID mychannel --name mychaincode --version 1.0 --package-id ${PACKAGE_ID} --sequence 1

# ORG2查询已安装链码并批准链码
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051
# 查询已安装链码
peer lifecycle chaincode queryinstalled
# 批准链码
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "$ORDERER_CA" --channelID mychannel --name mychaincode --version 1.0 --package-id ${PACKAGE_ID} --sequence 1

# 检查链码是否已准备好被提交
peer lifecycle chaincode checkcommitreadiness --channelID mychannel --name mychaincode --version 1.0 --sequence 1 --output json

# 提交链码
peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "$ORDERER_CA"  --channelID mychannel --name mychaincode --version 1.0 --sequence 1 --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA


# 查询提交的链码
peer lifecycle chaincode querycommitted --channelID mychannel --name mychaincode

# 调用链码
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "$ORDERER_CA" -C mychannel -n mychaincode -c '{"Args":["InitLedger"]}'