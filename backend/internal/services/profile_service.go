package services

import (
	"backend/internal/db"
	"backend/internal/models"
	"errors"
	"gorm.io/gorm"
)

var (
	ErrProfileDoesNotExists error = errors.New("profile does not exists")
	ErrProfileAlreadyExists error = errors.New("profile already exists")
)

func CreateProfile(info *models.Profile) error {
	var profile models.Profile

	if err := db.DB.First(&profile, "user_id=?", info.UserId).Error; err == nil {
		return ErrProfileAlreadyExists
	} else if !errors.Is(err, gorm.ErrRecordNotFound) {
		return err
	}

	profile = models.Profile{
		UserId:      info.UserId,
		Name:        info.Name,
		Surname:     info.Surname,
		Age:         info.Age,
		Gender:      info.Gender,
		Description: info.Description,
	}

	err := db.DB.Create(&profile).Error

	if err != nil {
		return err
	}

	return nil
}

func GetProfile(claims *models.TokenClaimsResponse, userId int) (*models.Profile, error) {
	var profile models.Profile
	var neededId int

	if userId == 0 {
		neededId = claims.UserID
	} else {
		neededId = userId
	}

	if err := db.DB.First(&profile, "user_id=?", neededId).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, ErrProfileDoesNotExists
		} else {
			return nil, err
		}
	}

	return &profile, nil
}

func UpdateProfile(userId int, updateReq *models.UpdateProfileRequest) (*models.Profile, error) {
	var profile models.Profile

	if err := db.DB.First(&profile, "user_id=?", userId).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, ErrProfileDoesNotExists
		} else {
			return nil, err
		}
	}

	if updateReq.Name != nil {
		profile.Name = *updateReq.Name
	}
	if updateReq.Surname != nil {
		profile.Surname = *updateReq.Surname
	}
	if updateReq.Age != nil {
		profile.Age = *updateReq.Age
	}
	if updateReq.Gender != nil {
		profile.Gender = *updateReq.Gender
	}
	if updateReq.Description != nil {
		profile.Description = *updateReq.Description
	}

	if err := db.DB.Save(&profile).Error; err != nil {
		return nil, err
	}

	return &profile, nil
}
