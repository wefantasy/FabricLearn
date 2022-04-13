## FabricLearn
本项目虚拟了一个工作室联盟链需求并将逐步实现，致力于提供一个易理解、可复现的Fabric学习项目，其中项目部署步骤的各个环节都清晰可见，并且将所有实验打包为脚本使之能够被快速复现在任何一台主机上。

## 背景介绍
有一启明星工作室，其中包含三大组织：软件组、WEB组、硬件组、理事会，不同组织间相互独立，偶尔有业务往来。现理事会决定搭建一个启明星工作室的联盟链网络，使不同组织间加强合作，期望最终实现以下工程架构：
  
1. 组织说明  
   - `council`：理事会，负责工作室各组间协调管理，由三组抽调人员共同组成
   - `soft`：软件组，专注软件开发
   - `hard`：硬件组，专注硬件开发
   - `web`：WEB组，专注网站开发
   - `orderer`：过渡排序组织，为联盟链网络提供排序服务，**后期会舍弃**
2. 成员说明  
   - `council`：一个Admin账号
   - `soft`：一个Peer节点、一个Admin账号、一个User账号
   - `hard`：一个Peer节点、一个Admin账号、一个User账号
   - `web`：一个Peer节点、一个Admin账号、一个User账号
   - `orderer`：一个Orderer节点、一个Admin账号
3. 根CA服务器（域名）  
   - `council.fantasy.com`：提供/管理**组织间**的`TLS`证书，又叫**TLS CA服务器**
   - `soft.fantasy.com`：提供/管理组织内`TLS`证书
   - `hard.fantasy.com`：提供/管理组织内`TLS`证书
   - `web.fantasy.com`：提供/管理组织内`TLS`证书  
   - `orderer.fantasy.com`：提供/管理组织内`TLS`证书  

## TODO
- [x] [基于Debian搭建Hyperledger Fabric 2.4开发环境及运行简单案例](https://ifantasy.net/2021/07/21/setup_hyperledger_fabric_environment_and_test_demo/#环境搭建)
- [x] [Hyperledger Fabric的test-network启动过程Bash源码详解](https://ifantasy.net/2022/03/29/hyperledger_fabric_0_test_network_explain/)
- [x] [Hyperledger Fabric定制联盟链网络工程实践](https://ifantasy.net/2022/04/01/hyperledger_fabric_1_custom_our_network/)
- [x] [Hyperledger Fabric组织的动态添加和删除](https://ifantasy.net/2022/04/04/hyperledger_fabric_2_update_org/)
- [x] [Hyperledger Fabric节点的动态添加和删除](https://ifantasy.net/2022/04/06/hyperledger_fabric_3_update_peer/)
- [x] [Hyperledger Fabric无系统通道启动及通道的创建和删除](https://ifantasy.net/2022/04/07/hyperledger_fabric_4_run_with_no_system_channel_and_update_channel/)
- [x] [Hyperledger Fabric无排序组织以Raft协议启动多个Orderer服务、多组织共同运行维护Orderer](https://ifantasy.net/2022/04/10/hyperledger_fabric_5_run_multi_orderer_by_oneself/)
- [x] [Hyperledger Fabric无排序组织以Raft协议启动多个Orderer服务、TLS组织运行维护Orderer服务](https://ifantasy.net/2022/04/11/hyperledger_fabric_6_run_multi_orderer_by_council/)
- [x] [Hyperledger Fabric多主机多节点启动网络](https://ifantasy.net/2022/04/13/hyperledger_fabric_7_run_network_on_multi_host/)
- [ ] Hyperledger Fabric通过K8S部署多机多节点网络

## 运行复现
不同阶段下的网络启动脚本不同，所有脚本都在对应目录的根目录下，一个示例启动顺序如下：
```bash
# 设置环境变量 
source envpeer1soft
# 启动CA网络 
./0_Restart.sh
# 注册用户 
./1_RegisterUser.sh
# 构造证书 
./2_EnrollUser.sh
# 配置通道 
./3_Configtxgen.sh
# 安装测试链码 
./4_TestChaincode.sh  
```

## 通用目录说明
```Shell
1_3Org2Peer1Orderer1TLS
├── setDNS.sh              # 设置本实验所需的DNS
├── 0_Restart.sh           # 启动基本 CA 网络脚本
├── 1_RegisterUser.sh      # 注册账户脚本
├── 2_EnrollUser.sh        # 登录账户脚本
├── 3_Configtxgen.sh       # 生成创世区块脚本
├── 4_TestChaincode.sh     # 链码测试脚本
├── asset-transfer-basic   # 测试链码目录
├── basic.tar.gz           # 打包后的链码包
├── compose                # Docker配置目录
│   ├── docker-base.yaml      # 基础通用配置
│   └── docker-compose.yaml   # 具体 Docker 配置
├── config                 # Fabric 公共配置目录
│   ├── config-msp.yaml    # 节点组织单元配置文件
│   ├── configtx.yaml      # 初始通道配置
│   ├── orderer.yaml      # orderer 节点配置，osnadmin 的配置文件
│   └── core.yaml          # peer 配置
├── data                   # 临时数据目录
├── envpeer1soft           # soft 组织的 peer1 cli环境变量
├── envpeer1web            # web 组织的peer1 cli环境变量
├── orgs                   # 组织成员证书目录
│   ├── council.ifantasy.net  # council 组织目录
│   ├── orderer.ifantasy.net  # orderer 组织目录
│   ├── web.ifantasy.net      # web组织目录
│   └── soft.ifantasy.net     # soft 组织目录
│       ├── assets            # 组织公共材料目录
│       │   ├── ca-cert.pem      # 本组织根证书
│       │   ├── mychannel.block  # mychannel 通道创世区块
│       │   └── tls-ca-cert.pem  # TLS-CA 服务根证书
│       ├── ca             # 本组织 CA 服务目录
│       │   ├── admin      # 本组织 CA 服务引导管理员 msp 目录
│       │   └── crypto     # 本组织 CA 服务默认证书目录
│       ├── msp               # 组织 MSP 目录
│       │   ├── admincerts    # 组织管理员签名证书目录
│       │   ├── cacerts       # 组织 CA 服务根证书目录
│       │   ├── config.yaml   # 组织节点单元配置文件
│       │   ├── tlscacerts    # TLS-CA 服务根证书目录
│       │   └── users         # 空目录，msp 规范所需
│       └── registers         # 本组织注册的账户目录
│           ├── admin1        # 管理员账户
│           └── peer1         # 节点账户
└── README.md              
```