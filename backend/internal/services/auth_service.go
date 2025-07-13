package services

import (
	"backend/internal/config"
	"backend/internal/db"
	"backend/internal/models"
	"backend/pkg/utils"
	"errors"
	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
	"time"
)

var (
	ErrUnknownUserOrPass   error = errors.New("unknown user or password")
	ErrUserExists          error = errors.New("user already exists")
	ErrInvalidInput        error = errors.New("invalid input")
	ErrInvalidToken        error = errors.New("invalid token")
	ErrCanNotGetClaims     error = errors.New("can not get claims")
	ErrInvalidRefreshToken error = errors.New("invalid refresh token")
)

func generateAccessToken(userID int, username string) (string, error) {
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user_id":  userID,
		"username": username,
		"exp":      time.Now().Add(20 * time.Minute).Unix(),
	})
	return token.SignedString([]byte(config.AppConfig.JWT.SecretKey))
}

func generateRefreshToken(userID int) (string, error) {
	expTime := time.Now().Add(14 * 24 * time.Hour)

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user_id": userID,
		"exp":     expTime.Unix(),
	})

	tokenString, err := token.SignedString([]byte(config.AppConfig.JWT.SecretKey))

	if err != nil {
		return "", err
	}

	refreshToken := models.RefreshToken{
		UserID:    userID,
		Token:     tokenString,
		ExpiresAt: expTime,
	}

	if err := db.DB.Create(&refreshToken).Error; err != nil {
		return "", err
	}

	return tokenString, nil
}

func RegisterUser(username, password string) (string, string, error) {
	// Hashing password
	hashed, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return "", "", err
	}

	// Checking for existent user
	var user models.User
	if err := db.DB.First(&user, "username = ?", username).Error; err == nil {
		return "", "", ErrUserExists
	} else if !errors.Is(err, gorm.ErrRecordNotFound) {
		return "", "", err
	}

	// Creating new user
	user = models.User{
		Username: username,
		Password: string(hashed),
	}
	if err := db.DB.Create(&user).Error; err != nil {
		return "", "", err
	}

	// Generating tokens
	accessToken, err := generateAccessToken(user.Id, user.Username)
	if err != nil {
		return "", "", err
	}

	refreshToken, err := generateRefreshToken(user.Id)
	if err != nil {
		return "", "", err
	}

	return accessToken, refreshToken, nil
}

func LoginUser(username, password string) (string, string, error) {
	// Searching user
	var user models.User
	if err := db.DB.First(&user, "username = ?", username).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return "", "", ErrUnknownUserOrPass
		}
		return "", "", err
	}

	// Checking passwords
	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(password)); err != nil {
		return "", "", ErrUnknownUserOrPass
	}

	// Generating tokens
	accessToken, err := generateAccessToken(user.Id, user.Username)
	if err != nil {
		return "", "", err
	}
	refreshToken, err := generateRefreshToken(user.Id)
	if err != nil {
		return "", "", err
	}

	return accessToken, refreshToken, nil
}

func GetTokenClaims(token string) (models.TokenClaimsResponse, error) {
	tokena, err := jwt.Parse(token, func(token *jwt.Token) (interface{}, error) {
		return []byte(config.AppConfig.JWT.SecretKey), nil
	}, jwt.WithValidMethods([]string{jwt.SigningMethodHS256.Alg()}))

	if err != nil {
		return models.TokenClaimsResponse{}, ErrInvalidToken
	}

	if claims, ok := tokena.Claims.(jwt.MapClaims); ok {
		var userId int
		var username string
		userId, err = utils.GetIntFromClaims(claims, "user_id")
		if err != nil {
			return models.TokenClaimsResponse{}, err
		}

		username, err = utils.GetStringFromClaims(claims, "username")
		if err != nil {
			return models.TokenClaimsResponse{}, err
		}

		return models.TokenClaimsResponse{
			UserID:   userId,
			Username: username,
		}, nil
	} else {
		return models.TokenClaimsResponse{}, ErrCanNotGetClaims
	}
}

func RefreshAccessToken(refreshToken string) (string, error) {
	var token models.RefreshToken
	// Check if the refresh token exists and is not expired
	if err := db.DB.Where("token = ?", refreshToken).First(&token).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return "", ErrInvalidRefreshToken
		}
		return "", err
	}

	// Check if the token is expired
	if token.ExpiresAt.Before(time.Now()) {
		if err := db.DB.Delete(&models.RefreshToken{}, "token = ?", refreshToken).Error; err != nil {
			return "", err
		}
		return "", ErrInvalidRefreshToken
	}

	// Fetch user
	var user models.User
	if err := db.DB.First(&user, "id = ?", token.UserID).Error; err != nil {
		return "", err
	}

	// Generate new access token
	newAccessToken, err := generateAccessToken(user.Id, user.Username)
	if err != nil {
		return "", err
	}

	return newAccessToken, nil
}
