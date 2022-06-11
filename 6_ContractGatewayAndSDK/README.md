### 本文工作
以无排序组织的方式启动 Hyperledger Fabric 网络，其中包含四个组织—— council 、 soft 、 web 、 hard ， council 组织为网络提供 TLS-CA 服务，并且运行维护着三个 orderer 服务；其余每个组织都运行维护着一个 peer 节点。网络结构为（实验代码已上传至：[https://github.com/wefantasy/FabricLearn](https://github.com/wefantasy/FabricLearn) 的 `6_ContractGatewayAndSDK` 下）：    

|               项                | 运行端口 |                           说明                           |
| :-----------------------------: | :------: | :------------------------------------------------------: |
|     `council.ifantasy.net`      |   7050   |  council 组织的 CA 服务， 为联盟链网络提供 TLS-CA 服务   |
| `orderer1.council.ifantasy.net` |   7051   |               council 组织的 orderer1 服务               |
| `orderer1.council.ifantasy.net` |   7052   |        council 组织的 orderer1 服务的 admin 服务         |
| `orderer2.council.ifantasy.net` |   7054   |               council 组织的 orderer2 服务               |
| `orderer2.council.ifantasy.net` |   7055   |        council 组织的 orderer2 服务的 admin 服务         |
| `orderer3.council.ifantasy.net` |   7057   |               council 组织的 orderer3 服务               |
| `orderer3.council.ifantasy.net` |   7058   |        council 组织的 orderer3 服务的 admin 服务         |
|       `soft.ifantasy.net`       |   7250   | soft 组织的 CA 服务， 包含成员： peer1 、 admin1 、user1 |
|    `peer1.soft.ifantasy.net`    |   7251   |                soft 组织的 peer1 成员节点                |
|       `web.ifantasy.net`        |   7350   | web 组织的 CA 服务， 包含成员： peer1 、 admin1 、user1  |
|    `peer1.web.ifantasy.net`     |   7351   |                web 组织的 peer1 成员节点                 |
|       `hard.ifantasy.net`       |   7450   | hard 组织的 CA 服务， 包含成员： peer1 、 admin1 、user1 |
|    `peer1.hard.ifantasy.net`    |   7451   |                hard 组织的 peer1 成员节点                |