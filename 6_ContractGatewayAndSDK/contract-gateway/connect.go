package main

import (
	"crypto/x509"
	"fmt"
	"io/ioutil"
	"path"
	"github.com/hyperledger/fabric-gateway/pkg/identity"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
)

const (
	mspID         = "softMSP"				// 所属组织的MSPID
	cryptoPath    = "/root/FabricLearn/6_ContractGatewayAndSDK/orgs/soft.ifantasy.net"	// 中间变量
	certPath      = cryptoPath + "/registers/user1/msp/signcerts/cert.pem"		// client 用户的签名证书
	keyPath       = cryptoPath + "/registers/user1/msp/keystore/"		// client 用户的私钥路径
	tlsCertPath   = cryptoPath + "/assets/tls-ca-cert.pem"			// client 用户的 tls 通信证书
	peerEndpoint  = "peer1.soft.ifantasy.net:7251"			// 所连 peer 节点的地址
	gatewayPeer   = "peer1.soft.ifantasy.net"		// 网关 peer 节点名称
)

// 创建指向联盟链网络的 gRPC 连接.
func newGrpcConnection() *grpc.ClientConn {
	certificate, err := loadCertificate(tlsCertPath)
	if err != nil {
		panic(err)
	}

	certPool := x509.NewCertPool()
	certPool.AddCert(certificate)
	transportCredentials := credentials.NewClientTLSFromCert(certPool, gatewayPeer)

	connection, err := grpc.Dial(peerEndpoint, grpc.WithTransportCredentials(transportCredentials))
	if err != nil {
		panic(fmt.Errorf("failed to create gRPC connection: %w", err))
	}

	return connection
}

// 根据用户指定的X.509证书为这个网关连接创建一个客户端标识。
func newIdentity() *identity.X509Identity {
	certificate, err := loadCertificate(certPath)
	if err != nil {
		panic(err)
	}

	id, err := identity.NewX509Identity(mspID, certificate)
	if err != nil {
		panic(err)
	}
	return id
}

// 加载证书文件
func loadCertificate(filename string) (*x509.Certificate, error) {
	certificatePEM, err := ioutil.ReadFile(filename)
	if err != nil {
		return nil, fmt.Errorf("failed to read certificate file: %w", err)
	}
	return identity.CertificateFromPEM(certificatePEM)
}

// 使用私钥从消息摘要生成数字签名
func newSign() identity.Sign {
	files, err := ioutil.ReadDir(keyPath)
	if err != nil {
		panic(fmt.Errorf("failed to read private key directory: %w", err))
	}
	privateKeyPEM, err := ioutil.ReadFile(path.Join(keyPath, files[0].Name()))

	if err != nil {
		panic(fmt.Errorf("failed to read private key file: %w", err))
	}

	privateKey, err := identity.PrivateKeyFromPEM(privateKeyPEM)
	if err != nil {
		panic(err)
	}

	sign, err := identity.NewPrivateKeySign(privateKey)
	if err != nil {
		panic(err)
	}

	return sign
}