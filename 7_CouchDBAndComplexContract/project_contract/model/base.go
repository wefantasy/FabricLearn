package model

import "time"

// 历史查询结果
type HistoryQueryResult[T interface{}] struct {
	Record    T         `json:"record"`
	TxId      string    `json:"txId"`
	Timestamp time.Time `json:"timestamp"`
	IsDelete  bool      `json:"isDelete"`
}

// 分页查询结果
type PaginatedQueryResult[T interface{}] struct {
	Records             []T    `json:"records"`
	FetchedRecordsCount int32  `json:"fetchedRecordsCount"`
	Bookmark            string `json:"bookmark"`
}
