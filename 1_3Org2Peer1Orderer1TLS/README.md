### 本文工作
本项目主要以学习为主，所以并未期望一次实现所有架构和功能。本文所实现的具体内容为，搭建一个简单的工作室联盟链网络，包含 `council` 、 `orderer` 、 `soft` 、 `web` 四个组织，并将测试链码部署在通道 `mychannel` ，网络结构为（实验代码已上传至：[https://github.com/wefantasy/FabricLearn](https://github.com/wefantasy/FabricLearn) 的 1_3Org2Peer1Orderer1TLS 目录下）： 

项    |   运行端口  |  说明
:---: | :---:  | :---:
`council.ifantasy.net` |   7050 |  council 组织的 CA 服务， 为联盟链网络提供 TLS-CA 服务
`orderer.ifantasy.net` |   7150 |  orderer 组织的 CA 服务， 为联盟链网络提供排序服务
`orderer1.orderer.ifantasy.net` |   7151 |  orderer 组织的 orderer1 成员节点
`soft.ifantasy.net` |   7250 |  soft 组织的 CA 服务， 包含成员： peer1 、 admin1
`peer1.soft.ifantasy.net` |   7251 |  soft 组织的 peer1 成员节点
`web.ifantasy.net` |   7350 |  web 组织的 CA 服务， 包含成员： peer1 、 admin1
`peer1.web.ifantasy.net` |   7351 |  web 组织的 peer1 成员节点