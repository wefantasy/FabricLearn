package main

import (
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
	"github.com/wefantasy/FabricLearn/7_IntermediateContract/project_contract/contract"
)

func main() {
	chaincode, err := contractapi.NewChaincode(&contract.UserContract{}, &contract.ProjectContract{})
	if err != nil {
		panic(err)
	}

	if err := chaincode.Start(); err != nil {
		panic(err)
	}
}
