#!/bin/bash -eu
# 创建组织证书
cryptogen generate --config=./organizations/cryptogen/crypto-config-org1.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-org2.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-orderer.yaml --output="organizations"

# 启动所有容器
docker-compose -f compose/compose-test-net.yaml -f compose/docker/docker-compose-test-net.yaml up -d
