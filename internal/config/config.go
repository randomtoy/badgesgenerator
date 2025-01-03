package config

import (
	"log"

	"github.com/spf13/viper"
)

type Config struct {
	Redis  RedisConfig
	Server ServerConfig
}

type RedisConfig struct {
	Host     string
	Port     int
	Password string
}

type ServerConfig struct {
	Port string
}

func LoadConfig(path string) *Config {
	viper.SetConfigName("config")
	viper.SetConfigType("yaml")
	viper.AddConfigPath(path)

	err := viper.ReadInConfig()
	if err != nil {
		log.Fatalf("Failed to read configuration: %v", err)
	}
	return &Config{
		Redis: RedisConfig{
			Host: viper.GetString("redis.host"),
		},
		Server: ServerConfig{
			Port: viper.GetString("server.port"),
		},
	}
}
