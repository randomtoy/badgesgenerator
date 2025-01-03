package service

import (
	"context"
	"fmt"
)

type Storage interface {
	Increment(ctx context.Context, key string) (int64, error)
}

type VisitorService struct {
	storage Storage
}

func NewVisitorService(storage Storage) *VisitorService {
	return &VisitorService{storage: storage}
}

func (vs *VisitorService) IncrementVisitorCounter(ctx context.Context, url string) (int64, error) {
	key := fmt.Sprintf("visitor:%s", url)
	return vs.storage.Increment(ctx, key)
}
