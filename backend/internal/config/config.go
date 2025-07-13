package config

import "os"

type Config struct {
	Database struct {
		User     string
		Password string
		Name     string
	}

	JWT struct {
		SecretKey string
	}

	Interest struct {
		Interests map[string]struct{}
	}

	Avatars struct {
		UploadDir   string
		MaxFileSize int64
	}
}

var AppConfig Config

func Load() {
	AppConfig.Database.User = os.Getenv("POSTGRES_USER")
	AppConfig.Database.Password = os.Getenv("POSTGRES_PASSWORD")
	AppConfig.Database.Name = os.Getenv("POSTGRES_DB")

	AppConfig.JWT.SecretKey = os.Getenv("SECRET_KEY")

	AppConfig.Interest.Interests = make(map[string]struct{}, 2)
	AppConfig.Interest.Interests["bicycle"] = struct{}{}
	AppConfig.Interest.Interests["swimming"] = struct{}{}

	AppConfig.Avatars.UploadDir = "./uploads/avatars"
	AppConfig.Avatars.MaxFileSize = 2 * 1024 * 1024

	if err := os.MkdirAll(AppConfig.Avatars.UploadDir, os.ModePerm); err != nil {
		panic("Failed to create avatar upload directory")
	}
}
