### 本文工作
以无系统通道的方式启动 Hyperledger Fabric 网络，然后先用 `configtxgen` 工具创建新通道 `mychannel` 和 `testchannel` ，并使用 `osnadmin` 工具通过 `orderer` 的 `admin` 服务使 `orderer` 加入这两条通道（实验代码已上传至：[https://github.com/wefantasy/FabricLearn](https://github.com/wefantasy/FabricLearn) 的 `3_RunWithNoSystemChannel` 下）[^2]：  

|               项                | 运行端口 |                         说明                          |
| :-----------------------------: | :------: | :---------------------------------------------------: |
|     `council.ifantasy.net`      |   7050   | council 组织的 CA 服务， 为联盟链网络提供 TLS-CA 服务 |
|     `orderer.ifantasy.net`      |   7150   |   orderer 组织的 CA 服务， 为联盟链网络提供排序服务   |
| `orderer1.orderer.ifantasy.net` |   7151   |                orderer 组织的排序服务                 |
| `orderer1.orderer.ifantasy.net` |   7152   |               orderer 组织的 ADMIN 服务               |
|       `soft.ifantasy.net`       |   7250   |   soft 组织的 CA 服务， 包含成员： peer1 、 admin1    |
|    `peer1.soft.ifantasy.net`    |   7251   |              soft 组织的 peer1 成员节点               |
|       `web.ifantasy.net`        |   7350   |    web 组织的 CA 服务， 包含成员： peer1 、 admin1    |
|    `peer1.web.ifantasy.net`     |   7351   |               web 组织的 peer1 成员节点               |