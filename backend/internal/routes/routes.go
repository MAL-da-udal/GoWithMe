package routes

import (
	api "backend/internal/api"
	"backend/internal/config"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
	"net/http"
	"strings"
)

func jwtMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {

		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "Authorization header is required"})
			return
		}

		parts := strings.SplitN(authHeader, " ", 2)
		if len(parts) != 2 || strings.ToLower(parts[0]) != "bearer" {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "Authorization header format must be Bearer {token}"})
			return
		}

		token := parts[1]

		c.Set("jwt", token)

		c.Next()
	}
}

func Setup() *gin.Engine {
	router := gin.Default()

	corsConfig := cors.DefaultConfig()
	corsConfig.AllowOrigins = config.AppConfig.Routes.CORSAddresses
	corsConfig.AllowMethods = []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"}
	corsConfig.AllowHeaders = []string{"Origin", "Content-Type", "Authorization"}
	corsConfig.AllowCredentials = true
	router.Use(cors.New(corsConfig))

	router.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))

	{
		auth := router.Group("/auth")
		auth.POST("/register", api.Register)
		auth.POST("/login", api.Login)
		auth.POST("/refresh", api.RefreshToken)

		authProtected := auth.Group("/")
		authProtected.Use(jwtMiddleware())
		authProtected.GET("/", api.GetTokenClaims)
	}

	{
		profile := router.Group("/profile")
		profile.Use(jwtMiddleware())
		profile.POST("/", api.CreateProfile)
		profile.GET("/", api.GetProfile)
		profile.PATCH("/", api.UpdateProfile)
	}

	{
		interests := router.Group("/interests")
		interests.Use(jwtMiddleware())
		interests.PUT("/", api.UpdateInterests)
		interests.GET("/", api.GetInterests)
		interests.GET("/all", api.GetUsersByInterests)
		interests.GET("/cats", api.GetAllInterests)
	}

	{
		avatar := router.Group("/avatar")
		avatar.Use(jwtMiddleware())
		avatar.PUT("/", api.UpdateAvatar)
		avatar.GET("/", api.GetAvatar)
	}

	return router
}
