package contract

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
	"github.com/wefantasy/FabricLearn/7_IntermediateContract/project_contract/model"
	"github.com/wefantasy/FabricLearn/7_IntermediateContract/project_contract/tools"
)

type ProjectContract struct {
	contractapi.Contract
}


// Exists 判断某项目是否存在
func (o *ProjectContract) Exists(ctx contractapi.TransactionContextInterface, index string) (bool, error) {
	resByte, err := ctx.GetStub().GetState(index)
	if err != nil {
		return false, fmt.Errorf("failed to read from world state: %v", err)
	}

	return resByte != nil, nil
}

// Insert 写入新记录
func (o *ProjectContract) Insert(ctx contractapi.TransactionContextInterface, pJSON string) error {
	var tx model.Project
	json.Unmarshal([]byte(pJSON), &tx)
	exists, err := o.Exists(ctx, tx.Index())
	if err != nil {
		return err
	}
	if exists {
		return fmt.Errorf("the data %s already exists", tx.Index())
	}
	txb, err := json.Marshal(tx)
	if err != nil {
		return err
	}
	ctx.GetStub().PutState(tx.Index(), txb)
	indexKey, err := ctx.GetStub().CreateCompositeKey(tx.IndexKey(), tx.IndexAttr())
	if err != nil {
		return err
	}
	value := []byte{0x00}
	fmt.Println("create success: ", tx)
	return ctx.GetStub().PutState(indexKey, value)
}

// Update 更新项目信息.
func (o *ProjectContract) Update(ctx contractapi.TransactionContextInterface, pJSON string) error {
	var tx model.Project
	json.Unmarshal([]byte(pJSON), &tx)

	otx, err := o.SelectByIndex(ctx, pJSON)
	if err != nil {
		return err
	}
	if otx == nil {
		return fmt.Errorf("the tx %s does not exist", tx.Index())
	}

	// 删除旧索引
	indexKey, err := ctx.GetStub().CreateCompositeKey(otx.IndexKey(), otx.IndexAttr())
	if err != nil {
		return err
	}
	ctx.GetStub().DelState(indexKey)

	txb, err := json.Marshal(tx)
	if err != nil {
		return err
	}
	ctx.GetStub().PutState(tx.Index(), txb)

	if indexKey, err = ctx.GetStub().CreateCompositeKey(tx.IndexKey(), tx.IndexAttr()); err != nil {
		return err
	}
	value := []byte{0x00}
	return ctx.GetStub().PutState(indexKey, value)
}

// Delete 删除指定pJSON的信息
func (o *ProjectContract) Delete(ctx contractapi.TransactionContextInterface, pJSON string) error {
	var tx model.Project
	json.Unmarshal([]byte(pJSON), &tx)

	anstx, err := o.SelectByIndex(ctx, pJSON)
	if err != nil {
		return err
	}
	if anstx == nil {
		return fmt.Errorf("the tx %s does not exist", tx.Index())
	}
	err = ctx.GetStub().DelState(anstx.Index())
	if err != nil {
		return fmt.Errorf("failed to delete transaction %s: %v", anstx.Index(), err)
	}

	indexKey, err := ctx.GetStub().CreateCompositeKey(tx.IndexKey(), tx.IndexAttr())
	if err != nil {
		return err
	}

	// Delete index entry
	return ctx.GetStub().DelState(indexKey)
}

// SelectByIndex 读取指定index的记录
func (o *ProjectContract) SelectByIndex(ctx contractapi.TransactionContextInterface, pJSON string) (*model.Project, error) {
	tx := model.Project{}
	json.Unmarshal([]byte(pJSON), &tx)
	queryString := fmt.Sprintf(`{"selector":{"ID":"%s", "table":"project"}}`, tx.ID)
	fmt.Println("select string: ", queryString)
	res, err := tools.SelectByQueryString[model.Project](ctx, queryString)
	if len(res) == 0 {
		return nil, err
	}
	return res[0], err
}

// SelectAll 读取所有记录
func (o *ProjectContract) SelectAll(ctx contractapi.TransactionContextInterface) ([]*model.Project, error) {
	queryString := fmt.Sprintf(`{"selector":{"table":"project"}}`)
	fmt.Println("select string: ", queryString)
	return tools.SelectByQueryString[model.Project](ctx, queryString)
}

// 按某索引查询所有数据
func (o *ProjectContract) SelectBySome(ctx contractapi.TransactionContextInterface, key, value string) ([]*model.Project, error) {
	queryString := fmt.Sprintf(`{"selector":{"%s":"%s", "table":"project"}}`, key, value)
	return tools.SelectByQueryString[model.Project](ctx, queryString)
}

// 富分页查询所有数据
func (o *ProjectContract) SelectAllWithPagination(ctx contractapi.TransactionContextInterface, pageSize int32, bookmark string) (string, error) {
	queryString := fmt.Sprintf(`{"selector":{"table":"project"}}`)
	fmt.Println("select string: ", queryString, "pageSize: ", pageSize, "bookmark", bookmark)
	res, err := tools.SelectByQueryStringWithPagination[model.Project](ctx, queryString, pageSize, bookmark)
	resb, _ := json.Marshal(res)
	fmt.Printf("select result: %v", res)
	return string(resb), err
}

// 按关键字富分页查询所有数据
func (o *ProjectContract) SelectBySomeWithPagination(ctx contractapi.TransactionContextInterface, key, value string, pageSize int32, bookmark string) (string, error) {
	queryString := fmt.Sprintf(`{"selector":{"%s":"%s","table":"project"}}`, key, value)
	fmt.Println("select string: ", queryString, "pageSize: ", pageSize, "bookmark", bookmark)
	res, err := tools.SelectByQueryStringWithPagination[model.Project](ctx, queryString, pageSize, bookmark)
	resb, _ := json.Marshal(res)
	fmt.Printf("select result: %v", res)
	return string(resb), err
}

// 按某索引查询数据历史
func (o *ProjectContract) SelectHistoryByIndex(ctx contractapi.TransactionContextInterface, pJSON string) (string, error) {
	var tx model.Project
	json.Unmarshal([]byte(pJSON), &tx)
	fmt.Println("select by tx: ", tx)
	res, err := tools.SelectHistoryByIndex[model.Project](ctx, tx.Index())
	resb, _ := json.Marshal(res)
	fmt.Printf("select result: %v", res)
	return string(resb), err
}

// 初始化智能合约数据
func (s *ProjectContract) InitLedger(ctx contractapi.TransactionContextInterface) error {
	projects := []model.Project{
		{ID: "FA8B31A55CD59DB352BCBF4D2AE791AD",
			Name:         "工作室联盟链管理系统",
			Username:     "fantasy",
			Organization: "Web",
			Category:     "blockchain",
			Url:          "https://github.com/wefantasy/FabricLearn",
			Describes:    "本项目虚拟了一个工作室联盟链需求并将逐步实现，致力于提供一个易理解、可复现的Fabric学习项目，其中项目部署步骤的各个环节都清晰可见，并且将所有实验打包为脚本使之能够被快速复现在任何一台主机上",
		},
	}
	for _, tx := range projects {
		txJsonByte, err := json.Marshal(tx)
		if err != nil {
			return err
		}
		err = s.Insert(ctx, string(txJsonByte))
		if err != nil {
			return err
		}
	}
	return nil
}
