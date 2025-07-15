package models

type Profile struct {
	Id          int    `json:"id" gorm:"primarykey"`
	UserId      int    `json:"user_id"`
	Name        string `json:"name"`
	Surname     string `json:"surname"`
	Age         int    `json:"age"`
	Gender      string `json:"gender"`
	Telegram    string `json:"telegram"`
	Description string `json:"description"`
}

type UpdateProfileRequest struct {
	Name        *string `json:"name"`
	Surname     *string `json:"surname"`
	Age         *int    `json:"age"`
	Gender      *string `json:"gender"`
	Description *string `json:"description"`
}
