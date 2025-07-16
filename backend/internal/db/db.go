package db

import (
	"backend/internal/config"
	"backend/internal/models"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"log"
)

var DB *gorm.DB

func MakeMigrations() {
	DB.AutoMigrate(&models.User{}, &models.Profile{}, &models.Interest{}, &models.RefreshToken{}, &models.Avatar{})
}

func Connect() {
	dsn := "host=" + config.AppConfig.Database.Host + " user=" + config.AppConfig.Database.User + " password=" + config.AppConfig.Database.Password + " dbname=" + config.AppConfig.Database.Name + " sslmode=disable TimeZone=Europe/Moscow"

	var err error
	DB, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})

	if err != nil {
		log.Fatalf("Error while connecting to database: %s\n", err.Error())
	}

	MakeMigrations()
}
