package routes

import (
	api "backend/internal/api"
	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

func Setup() *gin.Engine {
	router := gin.Default()
	router.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))

	{
		auth := router.Group("/auth")
		auth.POST("/register", api.Register)
		auth.POST("/login", api.Login)
		auth.POST("/refresh", api.RefreshToken)
		auth.GET("/", api.GetTokenClaims)
	}

	{
		profile := router.Group("/profile")
		profile.POST("/", api.CreateProfile)
		profile.GET("/", api.GetProfile)
		profile.PATCH("/", api.UpdateProfile)
	}

	{
		interests := router.Group("/interests")
		interests.PUT("/", api.UpdateInterests)
		interests.GET("/", api.GetInterests)
		interests.GET("/all", api.GetUsersByInterests)
	}

	{
		avatar := router.Group("/avatar")
		avatar.PUT("/", api.UpdateAvatar)
		avatar.GET("/", api.GetAvatar)
	}

	return router
}
