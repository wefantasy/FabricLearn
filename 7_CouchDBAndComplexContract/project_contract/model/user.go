package model

// User  用户表
type User struct {
	Table    string `json:"table" form:"table"`       //  数据库标记
	Username string `json:"username" form:"username"` //用户账户
	Name     string `json:"name" form:"name"`         //真实姓名
	Email    string `json:"email" form:"email"`       //  邮箱
	Phone    string `json:"phone" form:"phone"`       //  手机
}

func (o *User) Index() string {
	o.Table = "user"
	return o.Username
}

func (o *User) IndexKey() string {
	return "table~username~name"
}

func (o *User) IndexAttr() []string {
	return []string{o.Table, o.Username, o.Name}
}
