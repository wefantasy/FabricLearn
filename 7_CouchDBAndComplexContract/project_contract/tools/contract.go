package tools

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric-chaincode-go/shim"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
	"github.com/wefantasy/FabricLearn/7_IntermediateContract/project_contract/model"
)

// 根据查询结果生成切片
func ConstructResultByIterator[T interface{}](resultsIterator shim.StateQueryIteratorInterface) ([]*T, error) {
	var txs []*T
	for resultsIterator.HasNext() {
		queryResult, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}
		var tx T
		err = json.Unmarshal(queryResult.Value, &tx)
		if err != nil {
			return nil, err
		}
		txs = append(txs, &tx)
	}
	fmt.Println("select result length: ", len(txs))
	return txs, nil
}

// 根据查询字符串查询
func SelectByQueryString[T interface{}](ctx contractapi.TransactionContextInterface, queryString string) ([]*T, error) {
	resultsIterator, err := ctx.GetStub().GetQueryResult(queryString)
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()

	return ConstructResultByIterator[T](resultsIterator)
}

// 根据擦查询字符串分页查询
func SelectByQueryStringWithPagination[T interface{}](ctx contractapi.TransactionContextInterface, queryString string, pageSize int32, bookmark string) (*model.PaginatedQueryResult[T], error) {
	resultsIterator, responseMetadata, err := ctx.GetStub().GetQueryResultWithPagination(queryString, pageSize, bookmark)
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()
	var txs []T
	for resultsIterator.HasNext() {
		queryResult, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}
		var tx T
		err = json.Unmarshal(queryResult.Value, &tx)
		if err != nil {
			return nil, err
		}
		txs = append(txs, tx)
	}
	return &model.PaginatedQueryResult[T]{
		Records:             txs,
		FetchedRecordsCount: responseMetadata.FetchedRecordsCount,
		Bookmark:            responseMetadata.Bookmark,
	}, nil
}

// 获得交易创建之后的所有变化.
func SelectHistoryByIndex[T interface{}](ctx contractapi.TransactionContextInterface, index string) ([]model.HistoryQueryResult[T], error) {
	resultsIterator, err := ctx.GetStub().GetHistoryForKey(index)
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()

	var records []model.HistoryQueryResult[T]
	for resultsIterator.HasNext() {
		response, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}

		var tx T
		if len(response.Value) > 0 {
			err = json.Unmarshal(response.Value, &tx)
			if err != nil {
				return nil, err
			}
		}
		record := model.HistoryQueryResult[T]{
			TxId:      response.TxId,
			Record:    tx,
			IsDelete:  response.IsDelete,
		}
		records = append(records, record)
	}
	return records, nil
}
