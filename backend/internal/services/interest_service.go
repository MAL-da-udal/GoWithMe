package services

import (
	"backend/internal/config"
	"backend/internal/db"
	"backend/internal/models"
	"errors"
)

var (
	ErrUnknownInterest error = errors.New("unknown interest")
)

func SetInterests(claims *models.TokenClaimsResponse, interests []string) error {

	interestSet := make(map[string]struct{})
	for _, interest := range interests {
		if _, exists := config.AppConfig.Interest.Interests[interest]; exists {
			interestSet[interest] = struct{}{}
		} else {
			return ErrUnknownInterest
		}
	}

	err := db.DB.Where("user_id = ?", claims.UserID).Delete(&models.Interest{}).Error
	if err != nil {
		return err
	}

	for interest := range interestSet {
		err := db.DB.Create(&models.Interest{
			UserId:     claims.UserID,
			InterestId: interest,
		}).Error
		if err != nil {
			return err
		}
	}

	return nil
}

func GetInterests(claims *models.TokenClaimsResponse, userId int) ([]string, error) {
	var neededId int

	if userId == 0 {
		neededId = claims.UserID
	} else {
		neededId = userId
	}

	var interests []models.Interest
	err := db.DB.Where("user_id = ?", neededId).Find(&interests).Error

	if err != nil {
		return nil, err
	}

	ret := make([]string, 0, len(interests))

	for _, interest := range interests {
		ret = append(ret, interest.InterestId)
	}

	return ret, nil
}

func GetUsersByInterests(pageNum int, interests []string, pageSize int) (*models.PaginatedUsersResponse, error) {
	if pageNum < 1 {
		return nil, errors.New("invalid page number")
	}

	if len(interests) == 0 {
		return nil, errors.New("interests list cannot be empty")
	}

	var paginatedUserIDs []int
	err := db.DB.Table("interests").
		Select("DISTINCT user_id").
		Where("interest_id IN ?", interests).
		Order("user_id ASC").
		Offset((pageNum-1)*pageSize).
		Limit(pageSize).
		Pluck("user_id", &paginatedUserIDs).Error
	if err != nil {
		return nil, err
	}

	if len(paginatedUserIDs) == 0 {
		return &models.PaginatedUsersResponse{PageNum: pageNum, Users: make(map[int]models.UserProfileWithInterests)}, nil
	}

	var profiles []models.Profile
	err = db.DB.Where("user_id IN ?", paginatedUserIDs).Find(&profiles).Error
	if err != nil {
		return nil, err
	}

	userProfiles := make(map[int]models.Profile)
	for _, profile := range profiles {
		userProfiles[profile.UserId] = profile
	}

	var allInterests []models.Interest
	err = db.DB.Where("user_id IN ?", paginatedUserIDs).Find(&allInterests).Error
	if err != nil {
		return nil, err
	}

	userInterests := make(map[int][]string)
	for _, interest := range allInterests {
		userInterests[interest.UserId] = append(userInterests[interest.UserId], interest.InterestId)
	}

	response := &models.PaginatedUsersResponse{
		PageNum: pageNum,
		Users:   make(map[int]models.UserProfileWithInterests),
	}

	for _, userID := range paginatedUserIDs {
		if profile, exists := userProfiles[userID]; exists {
			response.Users[userID] = models.UserProfileWithInterests{
				Profile:   profile,
				Interests: userInterests[userID],
			}
		}
	}

	return response, nil
}

func GetAllInterests() []string {
	ret := make([]string, 0, len(config.AppConfig.Interest.Interests))

	for interest := range config.AppConfig.Interest.Interests {
		ret = append(ret, interest)
	}

	return ret
}
