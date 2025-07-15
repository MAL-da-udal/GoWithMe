package main

import (
	_ "backend/docs"
	"backend/internal/config"
	"backend/internal/db"
	"backend/internal/routes"
)

// @title GoWithMe API Documentation
// @version 1.0
// @license.name Apache 2.0
// @license.url http://www.apache.org/licenses/LICENSE-2.0.html
// @BasePath /
// @securityDefinitions.apikey BearerAuth
// @in header
// @name Authorization

func main() {
	config.Load()
	db.Connect()

	router := routes.Setup()
	router.Run(":8000")
}
