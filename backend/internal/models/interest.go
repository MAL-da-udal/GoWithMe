package models

type Interest struct {
	Id         int    `json:"id" gorm:"primarykey"`
	InterestId string `json:"interest_id"`
	UserId     int    `json:"user_id"`
}

type UpdateInterestsRequest struct {
	Interests []string `json:"interests"`
}

type AllInterestsResponse struct {
	Interests []string `json:"interests"`
}

type UserProfileWithInterests struct {
	Profile   Profile  `json:"profile"`
	Interests []string `json:"interests"`
}

type PaginatedUsersResponse struct {
	PageNum int                              `json:"page_num"`
	Users   map[int]UserProfileWithInterests `json:"users"`
}

type InterestsRequest struct {
	Interests []string `json:"interests"`
}
