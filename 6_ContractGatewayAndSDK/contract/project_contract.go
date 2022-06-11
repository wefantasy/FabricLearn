package main

import (
	"encoding/json"
	"fmt"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
	"log"
)

type ProjectContract struct {
	contractapi.Contract
}

type Project struct {
	ID           string `json:"ID"`             // 项目唯一ID
	Name         string `json:"Name"`           // 项目名称
	Developer    string `json:"Developer"`      // 项目主要负责人
	Organization string `json:"Organization"`   // 项目所属组织
	Category     string `json:"Category"`       // 项目所属类别 
	Url          string `json:"Url"`            // 项目介绍地址
	Describes    string `json:"Describes"`      // 项目描述
}

// 初始化智能合约数据
func (s *ProjectContract) InitLedger(ctx contractapi.TransactionContextInterface) error {
	projects := []Project{
		{ID: "FA8B31A55CD59DB352BCBF4D2AE791AD", Name: "工作室联盟链管理系统", Developer: "Fantasy", Organization: "Web", Category: "blockchain", Url: "https://github.com/wefantasy/FabricLearn", Describes: "本项目虚拟了一个工作室联盟链需求并将逐步实现，致力于提供一个易理解、可复现的Fabric学习项目，其中项目部署步骤的各个环节都清晰可见，并且将所有实验打包为脚本使之能够被快速复现在任何一台主机上"},
	}
	for _, project := range projects {
		projectJSON, err := json.Marshal(project)
		if err != nil {
			return err
		}
		err = ctx.GetStub().PutState(project.ID, projectJSON)
		if err != nil {
			return fmt.Errorf("failed to put to world state. %v", err)
		}
	}
	return nil
}

// 写入新项目
func (s *ProjectContract) CreateProject(ctx contractapi.TransactionContextInterface, id string, name string, developer string, organization string, category string, url string, describes string) error {
	exists, err := s.ProjectExists(ctx, id)
	if err != nil {
		return err
	}
	if exists {
		return fmt.Errorf("the project %s already exists", id)
	}

	project := Project{
		ID:           id,
		Name:         name,
		Developer:    developer,
		Organization: organization,
		Category:     category,
		Url:          url,
		Describes:    describes,
	}
	projectJSON, err := json.Marshal(project)
	if err != nil {
		return err
	}
	return ctx.GetStub().PutState(id, projectJSON)
}

// 读取指定ID的项目信息
func (s *ProjectContract) ReadProject(ctx contractapi.TransactionContextInterface, id string) (*Project, error) {
	projectJSON, err := ctx.GetStub().GetState(id)
	if err != nil {
		return nil, fmt.Errorf("failed to read from world state: %v", err)
	}
	if projectJSON == nil {
		return nil, fmt.Errorf("the project %s does not exist", id)
	}

	var project Project
	err = json.Unmarshal(projectJSON, &project)
	if err != nil {
		return nil, err
	}

	return &project, nil
}

// 更新项目信息.
func (s *ProjectContract) UpdateProject(ctx contractapi.TransactionContextInterface, id string, name string, developer string, organization string, category string, url string, describes string) error {
	exists, err := s.ProjectExists(ctx, id)
	if err != nil {
		return err
	}
	if !exists {
		return fmt.Errorf("the project %s does not exist", id)
	}

	project := Project{
		ID:           id,
		Name:         name,
		Developer:    developer,
		Organization: organization,
		Category:     category,
		Url:          url,
		Describes:    describes,
	}
	projectJSON, err := json.Marshal(project)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(id, projectJSON)
}

// 删除指定ID的项目信息
func (s *ProjectContract) DeleteProject(ctx contractapi.TransactionContextInterface, id string) error {
	exists, err := s.ProjectExists(ctx, id)
	if err != nil {
		return err
	}
	if !exists {
		return fmt.Errorf("the project %s does not exist", id)
	}

	return ctx.GetStub().DelState(id)
}

// 判断某项目是否存在
func (s *ProjectContract) ProjectExists(ctx contractapi.TransactionContextInterface, id string) (bool, error) {
	projectJSON, err := ctx.GetStub().GetState(id)
	if err != nil {
		return false, fmt.Errorf("failed to read from world state: %v", err)
	}

	return projectJSON != nil, nil
}

// 读取所有项目信息
func (s *ProjectContract) GetAllProjects(ctx contractapi.TransactionContextInterface) ([]*Project, error) {
	// GetStateByRange 查询参数为两个空字符串时即查询所有数据
	resultsIterator, err := ctx.GetStub().GetStateByRange("", "")
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()

	var projects []*Project
	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}

		var project Project
		err = json.Unmarshal(queryResponse.Value, &project)
		if err != nil {
			return nil, err
		}
		projects = append(projects, &project)
	}

	return projects, nil
}

func main() {
	chaincode, err := contractapi.NewChaincode(&ProjectContract{})
	if err != nil {
		log.Panicf("Error creating project-manage chaincode: %v", err)
	}

	if err := chaincode.Start(); err != nil {
		log.Panicf("Error starting project-manage chaincode: %v", err)
	}
}