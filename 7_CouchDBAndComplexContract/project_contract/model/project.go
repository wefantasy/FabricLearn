package model

type Project struct {
	Table        string `json:"table" form:"table"` //  数据库标记
	ID           string `json:"ID"`                 // 项目唯一ID
	Name         string `json:"Name"`               // 项目名称
	Username     string `json:"username"`           // 项目主要负责人
	Organization string `json:"Organization"`       // 项目所属组织
	Category     string `json:"Category"`           // 项目所属类别
	Url          string `json:"Url"`                // 项目介绍地址
	Describes    string `json:"Describes"`          // 项目描述
}

func (o *Project) Index() string {
	o.Table = "project"
	return o.ID
}

func (o *Project) IndexKey() string {
	return "table~ID~name"
}

func (o *Project) IndexAttr() []string {
	return []string{o.Table, o.ID, o.Name}
}
