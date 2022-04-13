### 本文工作
将 [Hyperledger Fabric无排序组织以Raft协议启动多个Orderer服务、TLS组织运行维护Orderer服务](https://ifantasy.net/2022/04/11/hyperledger_fabric_6_run_multi_orderer_by_council/) 中网络部署至两台主机上—— DebianA 和 DebianB，其中 DebianA 维护 council 和 soft 组织及相关节点， DebianB 维护 web 和 hard 组织及相关节点，网络结构为（实验代码已上传至：[https://github.com/wefantasy/FabricLearn](https://github.com/wefantasy/FabricLearn) 的 `5_FabricNetworkByMultiHost` 下）：  

项    | 所属主机    |   运行端口  |  说明
:---: | :---:  | :---:  | :---:
`council.ifantasy.net` |   DebianA |   7050 |  council 组织的 CA 服务， 为联盟链网络提供 TLS-CA 服务
`orderer1.council.ifantasy.net` |   DebianA |   7051 |  orderer1 的排序服务
`orderer1.council.ifantasy.net` |   DebianA |   7052 |  orderer1 的 admin 服务
`orderer2.council.ifantasy.net` |   DebianA |   7054 |  orderer2 的排序服务
`orderer2.council.ifantasy.net` |   DebianA |   7055 |  orderer2 的 admin 服务
`orderer3.council.ifantasy.net` |   DebianB |   7057 |  orderer3 的排序服务
`orderer3.council.ifantasy.net` |   DebianB |   7058 |  orderer3 的 admin 服务
`soft.ifantasy.net` |   DebianA |   7250 |  soft 组织的 CA 服务， 包含成员： peer1 、 admin1
`peer1.soft.ifantasy.net` |   DebianA |   7251 |  soft 组织的 peer1 成员节点
`web.ifantasy.net` |   DebianB |   7350 |  web 组织的 CA 服务， 包含成员： peer1 、 admin1
`peer1.web.ifantasy.net` |   DebianB |   7351 |  web 组织的 peer1 成员节点
`hard.ifantasy.net` |   DebianB |   7450 |  hard 组织的 CA 服务， 包含成员： peer1 、 admin1
`peer1.hard.ifantasy.net` |   DebianB |   7451 |  hard 组织的 peer1 成员节点

两个主机的相关信息为：

主机名    | 别名    |   网络地址  |  说明
:---: | :---:  | :---:  | :---:
DebianA |   host1 |   172.25.1.250 |  运行 council 和 soft
DebianB |   host2 |   172.25.1.251 |  运行 web 和 hard
