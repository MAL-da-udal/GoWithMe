package services

import (
	"backend/internal/config"
	"backend/internal/db"
	"backend/internal/models"
	"errors"
	"fmt"
	"gorm.io/gorm"
	"io"
	"mime/multipart"
	"net/http"
	"os"
	"path/filepath"
)

var (
	ErrInvalidFileType = errors.New("only JPEG and PNG files are allowed")
	ErrFileTooLarge    = errors.New("file size exceeds 2MB limit")
	ErrFileReadFailed  = errors.New("failed to read file")
	ErrAvatarNotFound  = errors.New("avatar not found")
)

func UploadAvatar(userID uint, file multipart.File, header *multipart.FileHeader) (string, error) {

	if header.Size > config.AppConfig.Avatars.MaxFileSize {
		return "", ErrFileTooLarge
	}

	ext := filepath.Ext(header.Filename)
	if ext != ".jpg" && ext != ".jpeg" && ext != ".png" {
		return "", ErrInvalidFileType
	}

	buffer := make([]byte, 512)
	_, err := file.Read(buffer)
	if err != nil && err != io.EOF {
		return "", ErrFileReadFailed
	}
	mimeType := http.DetectContentType(buffer)
	if mimeType != "image/jpeg" && mimeType != "image/png" {
		return "", ErrInvalidFileType
	}
	_, err = file.Seek(0, io.SeekStart)
	if err != nil {
		return "", errors.New("failed to reset file pointer")
	}

	filename := fmt.Sprintf("avatar_%d%s", userID, ext)
	filePath := filepath.Join(config.AppConfig.Avatars.UploadDir, filename)

	out, err := os.Create(filePath)
	if err != nil {
		return "", errors.New("failed to save file")
	}
	defer out.Close()

	_, err = io.Copy(out, file)

	if err != nil {
		return "", errors.New("failed to write file")
	}

	var avatar models.Avatar
	err = db.DB.Where("user_id = ?", userID).First(&avatar).Error
	if err == nil {

		oldPath := avatar.Path
		avatar.Path = filePath
		err = db.DB.Save(&avatar).Error
		if err != nil {
			return "", errors.New("failed to update avatar in database")
		}

		if oldPath != filePath {
			os.Remove(oldPath)
		}
	} else if errors.Is(err, gorm.ErrRecordNotFound) {

		avatar = models.Avatar{UserID: userID, Path: filePath}
		err = db.DB.Create(&avatar).Error
		if err != nil {
			return "", errors.New("failed to create avatar in database")
		}
	} else {
		return "", errors.New("database error")
	}

	return filePath, nil
}

func GetAvatarPath(userID int) (string, error) {
	var avatar models.Avatar

	err := db.DB.Where("user_id = ?", userID).First(&avatar).Error

	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return "", ErrAvatarNotFound
		}
		return "", err
	}

	return avatar.Path, nil
}
