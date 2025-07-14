package models

type User struct {
	Id       int    `json:"id" gorm:"primarykey"`
	Username string `json:"username"`
	Password string `json:"password"`
}
