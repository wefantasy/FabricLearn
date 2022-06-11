### 本文工作
本实验中向 Hyperledger Fabric 网络动态添加一个新组织 hard 和组织节点 ，网络结构为（实验代码已上传至：[https://github.com/wefantasy/FabricLearn](https://github.com/wefantasy/FabricLearn) 的 `2_FabricNetworkUpdate` 下）：  

|               项                | 运行端口 |                         说明                          |
| :-----------------------------: | :------: | :---------------------------------------------------: |
|     `council.ifantasy.net`      |   7050   | council 组织的 CA 服务， 为联盟链网络提供 TLS-CA 服务 |
|     `orderer.ifantasy.net`      |   7150   |   orderer 组织的 CA 服务， 为联盟链网络提供排序服务   |
| `orderer1.orderer.ifantasy.net` |   7151   |           orderer 组织的 orderer1 成员节点            |
|       `soft.ifantasy.net`       |   7250   |   soft 组织的 CA 服务， 包含成员： peer1 、 admin1    |
|    `peer1.soft.ifantasy.net`    |   7251   |              soft 组织的 peer1 成员节点               |
|       `web.ifantasy.net`        |   7350   |    web 组织的 CA 服务， 包含成员： peer1 、 admin1    |
|    `peer1.web.ifantasy.net`     |   7351   |               web 组织的 peer1 成员节点               |
|       `hard.ifantasy.net`       |   7450   |   hard 组织的 CA 服务， 包含成员： peer1 、 admin1    |
|    `peer1.hard.ifantasy.net`    |   7451   |              hard 组织的 peer1 成员节点               |