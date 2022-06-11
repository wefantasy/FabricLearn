#!/bin/bash -eu
# 部署链码
source envpeer1soft
# 该目录下必须存在main包
# peer lifecycle chaincode package basic.tar.gz --path contract --lang golang --label basic_1
peer lifecycle chaincode install basic.tar.gz
peer lifecycle chaincode queryinstalled
source envpeer1web
peer lifecycle chaincode install basic.tar.gz
peer lifecycle chaincode queryinstalled
source envpeer1hard
peer lifecycle chaincode install basic.tar.gz
peer lifecycle chaincode queryinstalled

export CHAINCODE_ID=basic_1:0f1f1ffc8e3865a9179e70a3c56237482b3eb4dcecd30ab51ab01a6f5d3daeff
source envpeer1soft
peer lifecycle chaincode approveformyorg -o orderer1.council.ifantasy.net:7051 --tls --cafile $ORDERER_CA  --channelID testchannel --name basic --version 1.0 --sequence 1 --waitForEvent --init-required --package-id $CHAINCODE_ID
peer lifecycle chaincode queryapproved -C testchannel -n basic --sequence 1
source envpeer1web
peer lifecycle chaincode approveformyorg -o orderer3.council.ifantasy.net:7057 --tls --cafile $ORDERER_CA  --channelID testchannel --name basic --version 1.0 --sequence 1 --waitForEvent --init-required --package-id $CHAINCODE_ID
peer lifecycle chaincode queryapproved -C testchannel -n basic --sequence 1
source envpeer1hard
peer lifecycle chaincode approveformyorg -o orderer2.council.ifantasy.net:7054 --tls --cafile $ORDERER_CA  --channelID testchannel --name basic --version 1.0 --sequence 1 --waitForEvent --init-required --package-id $CHAINCODE_ID
peer lifecycle chaincode queryapproved -C testchannel -n basic --sequence 1

peer lifecycle chaincode checkcommitreadiness -o orderer1.council.ifantasy.net:7051 --tls --cafile $ORDERER_CA --channelID testchannel --name basic --version 1.0 --sequence 1 --init-required

source envpeer1soft
peer lifecycle chaincode commit -o orderer2.council.ifantasy.net:7054 --tls --cafile $ORDERER_CA --channelID testchannel --name basic --init-required --version 1.0 --sequence 1 --peerAddresses peer1.soft.ifantasy.net:7251 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --peerAddresses peer1.web.ifantasy.net:7351 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE
peer lifecycle chaincode querycommitted --channelID testchannel --name basic -o orderer1.council.ifantasy.net:7051 --tls --cafile $ORDERER_CA --peerAddresses peer1.soft.ifantasy.net:7251 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE
peer chaincode invoke --isInit -o orderer1.council.ifantasy.net:7051 --tls --cafile $ORDERER_CA --channelID testchannel --name basic --peerAddresses peer1.soft.ifantasy.net:7251 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --peerAddresses peer1.web.ifantasy.net:7351 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE -c '{"Args":["InitLedger"]}'
sleep 5
peer chaincode invoke -o orderer1.council.ifantasy.net:7051 --tls --cafile $ORDERER_CA --channelID testchannel --name basic --peerAddresses peer1.soft.ifantasy.net:7251 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --peerAddresses peer1.web.ifantasy.net:7351 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE -c '{"Args":["GetAllProjects"]}'
# Error: endorsement failure during invoke. response: status:500 message:"make sure the chaincode fabcar has been successfully defined on channel testchannel and try again: chaincode definition for 'basic' exists, but chaincode is not installed"
# approveformyorg 的链码包与 install 的链码包ID不一致