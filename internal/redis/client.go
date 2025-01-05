package redis

import (
	"context"
	"fmt"
	"strconv"

	"github.com/redis/go-redis/v9"
)

type RedisClient struct {
	client *redis.Client
}

func NewRedisClient(ctx context.Context, address string, port int, password string) (*RedisClient, error) {

	client := redis.NewClient(&redis.Options{
		Addr:     address + ":" + strconv.Itoa(port),
		Password: password,
	})
	_, err := client.Ping(ctx).Result()
	if err != nil {
		return nil, fmt.Errorf("failed to ping redis: %w", err)
	}
	return &RedisClient{client: client}, nil
}

func (rc *RedisClient) Increment(ctx context.Context, key string) (int64, error) {
	return rc.client.Incr(ctx, key).Result()
}
