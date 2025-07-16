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

func CreateInterests() {
	interests := []string{
		"swimming",
		"cycling",
		"football",
		"basketball",
		"tennis",
		"running",
		"yoga",
		"golf",
		"skiing",
		"surfing",
		"hiking",
		"climbing",
		"kayaking",
		"fishing",
		"horse riding",
		"nature walks",
		"beach walks",
		"dog walking",
		"photography walks",
		"bird watching",
		"fitness",
		"weightlifting",
		"crossfit",
		"pilates",
		"dancing",
		"skateboarding",
		"snowboarding",
		"paragliding",
		"diving",
		"martial arts",
	}

	AppConfig.Interest.Interests = make(map[string]struct{}, 2)

	for _, interest := range interests {
		AppConfig.Interest.Interests[interest] = struct{}{}
	}
}

func Load() {
	AppConfig.Database.User = os.Getenv("POSTGRES_USER")
	AppConfig.Database.Password = os.Getenv("POSTGRES_PASSWORD")
	AppConfig.Database.Name = os.Getenv("POSTGRES_DB")

	AppConfig.JWT.SecretKey = os.Getenv("SECRET_KEY")

	CreateInterests()

	AppConfig.Avatars.UploadDir = "./uploads/avatars"
	AppConfig.Avatars.MaxFileSize = 2 * 1024 * 1024

	if err := os.MkdirAll(AppConfig.Avatars.UploadDir, os.ModePerm); err != nil {
		panic("Failed to create avatar upload directory")
	}
}
