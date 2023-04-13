#!/bin/bash -eu
# 部署链码
source envpeer1soft
# 该目录下必须存在main包
# peer lifecycle chaincode package basic.tar.gz --path project_contract --label basic_1
peer lifecycle chaincode install basic.tar.gz
peer lifecycle chaincode queryinstalled
source envpeer1web
peer lifecycle chaincode install basic.tar.gz
peer lifecycle chaincode queryinstalled
source envpeer1hard
peer lifecycle chaincode install basic.tar.gz
peer lifecycle chaincode queryinstalled

export CHAINCODE_ID=basic_1:0e04b7e74449db5aec617aa2f039432d2fafe3f79befeef4529b4383b366fed3
source envpeer1soft
peer lifecycle chaincode approveformyorg -o orderer1.council.ifantasy.net:7051 --tls --cafile $ORDERER_CA  --channelID testchannel --name basic --version 1.0 --sequence 1 --waitForEvent --package-id $CHAINCODE_ID
peer lifecycle chaincode queryapproved -C testchannel -n basic --sequence 1
source envpeer1web
peer lifecycle chaincode approveformyorg -o orderer3.council.ifantasy.net:7057 --tls --cafile $ORDERER_CA  --channelID testchannel --name basic --version 1.0 --sequence 1 --waitForEvent --package-id $CHAINCODE_ID
peer lifecycle chaincode queryapproved -C testchannel -n basic --sequence 1
source envpeer1hard
peer lifecycle chaincode approveformyorg -o orderer2.council.ifantasy.net:7054 --tls --cafile $ORDERER_CA  --channelID testchannel --name basic --version 1.0 --sequence 1 --waitForEvent --package-id $CHAINCODE_ID
peer lifecycle chaincode queryapproved -C testchannel -n basic --sequence 1

peer lifecycle chaincode checkcommitreadiness -o orderer1.council.ifantasy.net:7051 --tls --cafile $ORDERER_CA --channelID testchannel --name basic --version 1.0 --sequence 1

source envpeer1soft
peer lifecycle chaincode commit -o orderer2.council.ifantasy.net:7054 --tls --cafile $ORDERER_CA --channelID testchannel --name basic --version 1.0 --sequence 1 --peerAddresses peer1.soft.ifantasy.net:7251 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --peerAddresses peer1.web.ifantasy.net:7351 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE
peer lifecycle chaincode querycommitted --channelID testchannel --name basic -o orderer1.council.ifantasy.net:7051 --tls --cafile $ORDERER_CA --peerAddresses peer1.soft.ifantasy.net:7251 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE

peer chaincode invoke -o orderer1.council.ifantasy.net:7051 --tls --cafile $ORDERER_CA --channelID testchannel --name basic --peerAddresses peer1.soft.ifantasy.net:7251 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --peerAddresses peer1.web.ifantasy.net:7351 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE -c '{"Args":["UserContract:InitLedger"]}'
peer chaincode invoke -o orderer1.council.ifantasy.net:7051 --tls --cafile $ORDERER_CA --channelID testchannel --name basic --peerAddresses peer1.soft.ifantasy.net:7251 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --peerAddresses peer1.web.ifantasy.net:7351 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE -c '{"Args":["ProjectContract:InitLedger"]}'
sleep 5
peer chaincode invoke -o orderer1.council.ifantasy.net:7051 --tls --cafile $ORDERER_CA --channelID testchannel --name basic --peerAddresses peer1.soft.ifantasy.net:7251 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --peerAddresses peer1.web.ifantasy.net:7351 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE -c '{"Args":["UserContract:GetAllUsers"]}'
peer chaincode invoke -o orderer1.council.ifantasy.net:7051 --tls --cafile $ORDERER_CA --channelID testchannel --name basic --peerAddresses peer1.soft.ifantasy.net:7251 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --peerAddresses peer1.web.ifantasy.net:7351 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE -c '{"Args":["ProjectContract:SelectAll"]}'
peer chaincode invoke -o orderer1.council.ifantasy.net:7051 --tls --cafile $ORDERER_CA --channelID testchannel --name basic --peerAddresses peer1.soft.ifantasy.net:7251 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --peerAddresses peer1.web.ifantasy.net:7351 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE -c '{"Args":["ProjectContract:SelectBySome", "name", "工作室联盟链管理系统"]}'