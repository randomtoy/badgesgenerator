package main

import (
	"context"
	"log"

	"github.com/randomtoy/badgesgenerator/internal/config"
	"github.com/randomtoy/badgesgenerator/internal/http"
	"github.com/randomtoy/badgesgenerator/internal/redis"
	"github.com/randomtoy/badgesgenerator/internal/service"
)

func main() {
	ctx := context.Background()
	cfg := config.LoadConfig("./config")

	redisClient, err := redis.NewRedisClient(ctx, cfg.Redis.Host)
	if err != nil {
		log.Fatalf("Failed to connect to Redis: %v", err)
	}
	visitorService := service.NewVisitorService(redisClient)
	http.StartServer(visitorService, cfg.Server.Port)
}
