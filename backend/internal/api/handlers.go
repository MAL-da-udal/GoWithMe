package api

import (
	"backend/internal/models"
	"backend/internal/services"
	"errors"
	"github.com/gin-gonic/gin"
	"strconv"
	"strings"
)

// @Summary Register user
// @Description Registers user with provided login and password
// @Tags Authorization
// @Accept json
// @Produce json
// @Param username query string true "Username"
// @Param password query string true "Password"
// @Success 200 {object} map[string]string
// @Router /auth/register [post]
func Register(ctx *gin.Context) {
	username := ctx.Query("username")
	password := ctx.Query("password")

	if len(username) == 0 || len(password) == 0 {
		ctx.JSON(400, models.ErrorResponse{Details: services.ErrInvalidInput.Error()})
		return
	}

	accessToken, refreshToken, err := services.RegisterUser(username, password)
	if err != nil {
		if errors.Is(err, services.ErrUserExists) {
			ctx.JSON(400, models.ErrorResponse{Details: err.Error()})
		} else {
			ctx.JSON(500, models.ErrorResponse{Details: "Internal server error"})
		}
		return
	}

	ctx.JSON(200, models.RegisterResponse{AccessToken: accessToken, RefreshToken: refreshToken})
}

// @Summary Login user
// @Description Checks credentials and gives JWT if alles ist gut
// @Tags Authorization
// @Accept json
// @Produce json
// @Param username query string true "Username"
// @Param password query string true "Password"
// @Success 200 {object} map[string]string
// @Router /auth/login [post]
func Login(ctx *gin.Context) {
	username := ctx.Query("username")
	password := ctx.Query("password")

	if len(username) == 0 || len(password) == 0 {
		ctx.JSON(400, models.ErrorResponse{Details: services.ErrInvalidInput.Error()})
		return
	}

	accessToken, refreshToken, err := services.LoginUser(username, password)
	if err != nil {
		if errors.Is(err, services.ErrUnknownUserOrPass) {
			ctx.JSON(400, models.ErrorResponse{Details: err.Error()})
		} else {
			ctx.JSON(500, models.ErrorResponse{Details: "Internal server error"})
		}
		return
	}

	ctx.JSON(200, models.LoginResponse{AccessToken: accessToken, RefreshToken: refreshToken})
}

// @Summary Refresh access token
// @Description Refreshes access token using refresh token
// @Tags Authorization
// @Accept json
// @Produce json
// @Param refresh_token body models.RefreshRequest true "Refresh Token"
// @Success 200 {object} map[string]string
// @Router /auth/refresh [post]
func RefreshToken(ctx *gin.Context) {

	var refreshRequest models.RefreshRequest

	if err := ctx.ShouldBindJSON(&refreshRequest); err != nil {
		ctx.JSON(400, models.ErrorResponse{Details: "Refresh token is required"})
		return
	}

	newAccessToken, err := services.RefreshAccessToken(refreshRequest.RefreshToken)
	if err != nil {
		if errors.Is(err, services.ErrInvalidRefreshToken) {
			ctx.JSON(401, models.ErrorResponse{Details: err.Error()})
		} else {
			ctx.JSON(500, models.ErrorResponse{Details: "Internal server error"})
		}
		return
	}

	ctx.JSON(200, map[string]string{"access_token": newAccessToken})
}

// @Summary Get token claims
// @Description Validates token, and if it valid returns it's claims
// @Tags Authorization
// @Accept json
// @Produce json
// @Security BearerAuth
// @Success 200 {object} map[string]string
// @Router /auth/ [get]
func GetTokenClaims(ctx *gin.Context) {
	tokenParam, _ := ctx.Get("jwt")
	token := tokenParam.(string)

	if len(token) == 0 {
		ctx.JSON(400, models.ErrorResponse{Details: services.ErrInvalidInput.Error()})
		return
	}

	claims, err := services.GetTokenClaims(token)
	if err != nil {
		if errors.Is(err, services.ErrInvalidToken) {
			ctx.JSON(401, models.ErrorResponse{Details: err.Error()})
			return
		} else {
			ctx.JSON(500, models.ErrorResponse{Details: err.Error()})
			return
		}
	}

	ctx.JSON(200, claims)
}

// @Summary Create profile
// @Description Creates profile
// @Tags Profile
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param profile_info body models.Profile true "Profile Info"
// @Success 200 {object} map[string]string
// @Router /profile/ [post]
func CreateProfile(ctx *gin.Context) {
	var req models.Profile
	tokenParam, _ := ctx.Get("jwt")
	token := tokenParam.(string)

	if len(token) == 0 {
		ctx.JSON(400, models.ErrorResponse{Details: services.ErrInvalidInput.Error()})
		return
	}

	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(400, models.ErrorResponse{Details: services.ErrInvalidInput.Error()})
		return
	}

	claims, err := services.GetTokenClaims(token)
	if err != nil {
		if errors.Is(err, services.ErrInvalidToken) {
			ctx.JSON(401, models.ErrorResponse{Details: err.Error()})
			return
		} else {
			ctx.JSON(500, models.ErrorResponse{Details: err.Error()})
			return
		}
	}

	toCreate := models.Profile{
		UserId:      claims.UserID,
		Name:        req.Name,
		Surname:     req.Surname,
		Age:         req.Age,
		Gender:      req.Gender,
		Description: req.Description,
	}

	err = services.CreateProfile(&toCreate)

	if err != nil {
		if errors.Is(err, services.ErrProfileAlreadyExists) {
			ctx.JSON(400, models.ErrorResponse{Details: err.Error()})
			return
		} else {
			ctx.JSON(500, models.ErrorResponse{Details: err.Error()})
			return
		}
	}

	ctx.JSON(201, map[string]interface{}{
		"details": "Created successfully",
	})
}

// @Summary Get profile
// @Description Returns profile info of specified user id. If not specified, returns profile info of user encoded in jwt
// @Tags Profile
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param user_id query int false "User ID"
// @Success 200 {object} models.Profile
// @Router /profile/ [get]
func GetProfile(ctx *gin.Context) {
	tokenParam, _ := ctx.Get("jwt")
	token := tokenParam.(string)

	if len(token) == 0 {
		ctx.JSON(400, models.ErrorResponse{Details: services.ErrInvalidInput.Error()})
		return
	}

	var neededUserId int

	if len(ctx.Query("user_id")) == 0 {
		neededUserId = 0
	} else {
		var err error
		neededUserId, err = strconv.Atoi(ctx.Query("user_id"))

		if err != nil {
			ctx.JSON(400, models.ErrorResponse{Details: err.Error()})
			return
		}
	}

	claims, err := services.GetTokenClaims(token)
	if err != nil {
		if errors.Is(err, services.ErrInvalidToken) {
			ctx.JSON(401, models.ErrorResponse{Details: err.Error()})
			return
		} else {
			ctx.JSON(500, models.ErrorResponse{Details: err.Error()})
			return
		}
	}

	info, err := services.GetProfile(&claims, neededUserId)

	if err != nil {
		if errors.Is(err, services.ErrProfileDoesNotExists) {
			ctx.JSON(400, models.ErrorResponse{Details: err.Error()})
			return
		} else {
			ctx.JSON(500, models.ErrorResponse{Details: err.Error()})
			return
		}
	}

	ctx.JSON(200, info)
}

// @Summary Update profile
// @Description Partially updates profile information
// @Tags Profile
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param profile_info body models.UpdateProfileRequest true "Profile Info to update"
// @Success 200 {object} models.Profile
// @Router /profile/ [patch]
func UpdateProfile(ctx *gin.Context) {
	tokenParam, _ := ctx.Get("jwt")
	token := tokenParam.(string)

	if len(token) == 0 {
		ctx.JSON(400, models.ErrorResponse{Details: services.ErrInvalidInput.Error()})
		return
	}

	var req models.UpdateProfileRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(400, models.ErrorResponse{Details: services.ErrInvalidInput.Error()})
		return
	}

	claims, err := services.GetTokenClaims(token)
	if err != nil {
		if errors.Is(err, services.ErrInvalidToken) {
			ctx.JSON(401, models.ErrorResponse{Details: err.Error()})
			return
		} else {
			ctx.JSON(500, models.ErrorResponse{Details: err.Error()})
			return
		}
	}

	updatedProfile, err := services.UpdateProfile(claims.UserID, &req)
	if err != nil {
		if errors.Is(err, services.ErrProfileDoesNotExists) {
			ctx.JSON(404, models.ErrorResponse{Details: err.Error()})
			return
		} else {
			ctx.JSON(500, models.ErrorResponse{Details: err.Error()})
			return
		}
	}

	ctx.JSON(200, updatedProfile)
}

// @Summary Update user's interests
// @Tags Interests
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param interests body models.UpdateInterestsRequest true "Interests to set"
// @Router /interests/ [put]
func UpdateInterests(ctx *gin.Context) {
	tokenParam, _ := ctx.Get("jwt")
	token := tokenParam.(string)

	if len(token) == 0 {
		ctx.JSON(400, models.ErrorResponse{Details: services.ErrInvalidInput.Error()})
		return
	}

	var req models.UpdateInterestsRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(400, models.ErrorResponse{Details: services.ErrInvalidInput.Error()})
		return
	}

	claims, err := services.GetTokenClaims(token)
	if err != nil {
		if errors.Is(err, services.ErrInvalidToken) {
			ctx.JSON(401, models.ErrorResponse{Details: err.Error()})
			return
		} else {
			ctx.JSON(500, models.ErrorResponse{Details: err.Error()})
			return
		}
	}

	err = services.SetInterests(&claims, req.Interests)
	if err != nil {
		if errors.Is(err, services.ErrUnknownInterest) {
			ctx.JSON(400, models.ErrorResponse{Details: err.Error()})
			return
		} else {
			ctx.JSON(500, models.ErrorResponse{Details: err.Error()})
			return
		}
	}

	ctx.JSON(200, map[string]string{"details": "Interests updated successfully"})
}

// @Summary Get user's interests
// @Tags Interests
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param user_id query int false "User ID"
// @Router /interests/ [get]
func GetInterests(ctx *gin.Context) {
	tokenParam, _ := ctx.Get("jwt")
	token := tokenParam.(string)

	if len(token) == 0 {
		ctx.JSON(400, models.ErrorResponse{Details: services.ErrInvalidInput.Error()})
		return
	}

	var neededUserId int

	if len(ctx.Query("user_id")) == 0 {
		neededUserId = 0
	} else {
		var err error
		neededUserId, err = strconv.Atoi(ctx.Query("user_id"))

		if err != nil {
			ctx.JSON(400, models.ErrorResponse{Details: err.Error()})
			return
		}
	}

	claims, err := services.GetTokenClaims(token)
	if err != nil {
		if errors.Is(err, services.ErrInvalidToken) {
			ctx.JSON(401, models.ErrorResponse{Details: err.Error()})
			return
		} else {
			ctx.JSON(500, models.ErrorResponse{Details: err.Error()})
			return
		}
	}

	interests, err := services.GetInterests(&claims, neededUserId)

	if err != nil {
		ctx.JSON(500, models.ErrorResponse{Details: err.Error()})
		return
	}

	ctx.JSON(200, map[string]interface{}{
		"details": interests,
	})
}

// @Summary Get users by interests
// @Description Retrieves paginated users who have specified interests, along with their profiles and all interests
// @Tags Interests
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param page_num query int true "Page number (starting from 1)"
// @Param page_size query int false "Number of users per page" default(10)
// @Param interests query string true "Semicolon-separated list of interest IDs (e.g., bicycle;swimming)"
// @Success 200 {object} models.PaginatedUsersResponse "Paginated users with profiles and interests"
// @Failure 400 {object} models.ErrorResponse "Invalid input (e.g., missing token, invalid page number, or empty interests)"
// @Failure 401 {object} models.ErrorResponse "Invalid or unauthorized token"
// @Failure 500 {object} models.ErrorResponse "Internal server error"
// @Router /interests/all [get]
func GetUsersByInterests(ctx *gin.Context) {
	// Extract and validate token
	tokenParam, _ := ctx.Get("jwt")
	token := tokenParam.(string)

	if len(token) == 0 {
		ctx.JSON(400, models.ErrorResponse{Details: "Token is required"})
		return
	}

	// Extract and validate page number
	pageNumStr := ctx.Query("page_num")
	pageNum, err := strconv.Atoi(pageNumStr)
	if err != nil || pageNum < 1 {
		ctx.JSON(400, models.ErrorResponse{Details: "Invalid page number"})
		return
	}

	// Extract and validate page size (default to 10)
	pageSizeStr := ctx.DefaultQuery("page_size", "10")
	pageSize, err := strconv.Atoi(pageSizeStr)
	if err != nil || pageSize < 1 {
		ctx.JSON(400, models.ErrorResponse{Details: "Invalid page size"})
		return
	}

	// Extract and split interests
	interestsStr := ctx.Query("interests")
	if len(interestsStr) == 0 {
		ctx.JSON(400, models.ErrorResponse{Details: "Interests are required"})
		return
	}
	interests := strings.Split(interestsStr, ";")

	// Validate token
	_, err = services.GetTokenClaims(token)
	if err != nil {
		if errors.Is(err, services.ErrInvalidToken) {
			ctx.JSON(401, models.ErrorResponse{Details: "Invalid token"})
		} else {
			ctx.JSON(500, models.ErrorResponse{Details: "Internal server error"})
		}
		return
	}

	// Call service to get users
	response, err := services.GetUsersByInterests(pageNum, interests, pageSize)
	if err != nil {
		ctx.JSON(500, models.ErrorResponse{Details: err.Error()})
		return
	}

	ctx.JSON(200, response)
}

// @Summary Update user avatar
// @Description Updates the avatar image for the authenticated user. Supports JPEG and PNG files up to 2MB.
// @Tags Avatar
// @Accept multipart/form-data
// @Produce json
// @Security BearerAuth
// @Param avatar formData file true "Avatar image file (JPEG or PNG)"
// @Success 200 {object} map[string]string "Avatar uploaded successfully"
// @Failure 400 {object} models.ErrorResponse "Invalid input (e.g., file too large, wrong format)"
// @Failure 401 {object} models.ErrorResponse "Invalid or unauthorized token"
// @Failure 500 {object} models.ErrorResponse "Server error"
// @Router /avatar [put]
func UpdateAvatar(ctx *gin.Context) {

	tokenParam, _ := ctx.Get("jwt")
	token := tokenParam.(string)

	if len(token) == 0 {
		ctx.JSON(400, models.ErrorResponse{Details: "Token is required"})
		return
	}

	claims, err := services.GetTokenClaims(token)
	if err != nil {
		if errors.Is(err, services.ErrInvalidToken) {
			ctx.JSON(401, models.ErrorResponse{Details: "Invalid token"})
		} else {
			ctx.JSON(500, models.ErrorResponse{Details: "Internal server error"})
		}
		return
	}

	file, header, err := ctx.Request.FormFile("avatar")
	if err != nil {
		ctx.JSON(400, models.ErrorResponse{Details: "Failed to get file"})
		return
	}
	defer file.Close()

	_, err = services.UploadAvatar(uint(claims.UserID), file, header)
	if err != nil {
		if errors.Is(err, services.ErrFileTooLarge) || errors.Is(err, services.ErrInvalidFileType) || errors.Is(err, services.ErrFileReadFailed) {
			ctx.JSON(400, models.ErrorResponse{Details: err.Error()})
		} else {
			ctx.JSON(500, models.ErrorResponse{Details: "Internal server error"})
		}
		return
	}

	ctx.JSON(200, map[string]string{"details": "Avatar uploaded successfully"})
}

// @Summary Get user avatar
// @Description Retrieves the avatar image for the specified user or the authenticated user if no user_id is provided.
// @Tags Avatar
// @Produce image/jpeg,image/png
// @Security BearerAuth
// @Param user_id query int false "User ID"
// @Success 200 {file} file "Image"
// @Failure 400 {object} models.ErrorResponse "Invalid input"
// @Failure 401 {object} models.ErrorResponse "Invalid or unauthorized token"
// @Failure 404 {object} models.ErrorResponse "Avatar not found"
// @Failure 500 {object} models.ErrorResponse "Server error"
// @Router /avatar [get]
func GetAvatar(ctx *gin.Context) {

	tokenParam, _ := ctx.Get("jwt")
	token := tokenParam.(string)

	if len(token) == 0 {
		ctx.JSON(400, models.ErrorResponse{Details: "Token is required"})
		return
	}

	claims, err := services.GetTokenClaims(token)
	if err != nil {
		if errors.Is(err, services.ErrInvalidToken) {
			ctx.JSON(401, models.ErrorResponse{Details: "Invalid token"})
		} else {
			ctx.JSON(500, models.ErrorResponse{Details: "Internal server error"})
		}
		return
	}

	var targetUserId int
	userIdStr := ctx.Query("user_id")
	if userIdStr == "" {
		targetUserId = claims.UserID
	} else {
		parsedId, err := strconv.Atoi(userIdStr)
		if err != nil || parsedId < 1 {
			ctx.JSON(400, models.ErrorResponse{Details: "Invalid user_id"})
			return
		}
		targetUserId = parsedId
	}

	path, err := services.GetAvatarPath(targetUserId)
	if err != nil {
		if errors.Is(err, services.ErrAvatarNotFound) {
			ctx.JSON(404, models.ErrorResponse{Details: "Avatar not found"})
		} else {
			ctx.JSON(500, models.ErrorResponse{Details: "Internal server error"})
		}
		return
	}

	ctx.File(path)
}
