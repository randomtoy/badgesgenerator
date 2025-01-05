package config

import (
	"log"

	"github.com/spf13/viper"
)

type Config struct {
	Redis  RedisConfig  `mapstructure:",squash"`
	Server ServerConfig `mapstructure:",squash"`
}

type RedisConfig struct {
	Host     string `mapstructure:"REDIS_HOST"`
	Port     int    `mapstructure:"REDIS_PORT"`
	Password string `mapstructure:"REDIS_PASSWORD"`
}

type ServerConfig struct {
	Port string `mapstructure:"PORT"`
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

func LoadEnvConfig() *Config {
	viper.AutomaticEnv()

	viper.SetDefault("PORT", "8080")
	viper.SetDefault("REDIS_HOST", "localhost")
	viper.SetDefault("REDIS_PORT", 6379)
	viper.SetDefault("REDIS_PASSWORD", "")

	var config Config
	err := viper.Unmarshal(&config)
	if err != nil {
		log.Fatalf("Failed to unmarshal configuration: %v", err)
	}
	return &config
}
