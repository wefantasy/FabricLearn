package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"

	"github.com/hyperledger/fabric-sdk-go/pkg/core/config"
	"github.com/hyperledger/fabric-sdk-go/pkg/gateway"
)

func main() {
	log.Println("============ application-golang starts ============")

	err := os.Setenv("DISCOVERY_AS_LOCALHOST", "true")
	if err != nil {
		log.Fatalf("Error setting DISCOVERY_AS_LOCALHOST environemnt variable: %v", err)
	}

	wallet, err := gateway.NewFileSystemWallet("wallet")
	if err != nil {
		log.Fatalf("Failed to create wallet: %v", err)
	}

	err = populateWallet(wallet)
	// 调试建议注释这里
	// if !wallet.Exists("appUser") {
	// 	err = populateWallet(wallet)
	// 	if err != nil {
	// 		log.Fatalf("Failed to populate wallet contents: %v", err)
	// 	}
	// }

	ccpPath := filepath.Join(
		"connection-soft.yaml",
	)

	gw, err := gateway.Connect(
		gateway.WithConfig(config.FromFile(filepath.Clean(ccpPath))),
		gateway.WithIdentity(wallet, "appUser"),
	)
	if err != nil {
		log.Fatalf("Failed to connect to gateway: %v", err)
	}
	defer gw.Close()
	
	network, err := gw.GetNetwork("testchannel")
	if err != nil {
		log.Fatalf("Failed to get network: %v", err)
	}
	
	contract := network.GetContract("basic")

	log.Println("--> Evaluate Transaction: GetAllAssets, function returns all the current assets on the ledger")
	result, err := contract.EvaluateTransaction("GetAllProjects")
	if err != nil {
		log.Fatalf("Failed to evaluate transaction: %v", err)
	}
	log.Println(string(result))

	log.Println("--> Submit Transaction: DeleteProject, delete new project info with ID arguments")
	result, err = contract.SubmitTransaction("DeleteProject", "FA8B31A55CD59DB352BCBF4D2AE791AD")
	if err != nil {
		log.Fatalf("Failed to Submit transaction: %v", err)
	}
	log.Println(string(result))
}

func populateWallet(wallet *gateway.Wallet) error {
	log.Println("============ Populating wallet ============")
	credPath := filepath.Join(
		"..",
		"orgs",
		"soft.ifantasy.net",
		"registers",
		"user1",
		"msp",
	)

	certPath := filepath.Join(credPath, "signcerts", "cert.pem")
	// read the certificate pem
	cert, err := ioutil.ReadFile(filepath.Clean(certPath))
	if err != nil {
		return err
	}

	keyDir := filepath.Join(credPath, "keystore")
	// there's a single file in this dir containing the private key
	files, err := ioutil.ReadDir(keyDir)
	if err != nil {
		return err
	}
	if len(files) != 1 {
		return fmt.Errorf("keystore folder should have contain one file")
	}
	keyPath := filepath.Join(keyDir, files[0].Name())
	key, err := ioutil.ReadFile(filepath.Clean(keyPath))
	if err != nil {
		return err
	}

	identity := gateway.NewX509Identity("softMSP", string(cert), string(key))

	return wallet.Put("appUser", identity)
}
