package redis

import (
	"context"
	"testing"

	"github.com/go-redis/redismock/v8"
	"github.com/stretchr/testify/assert"
)

func TestClient_Increment(t *testing.T) {
	db, mock := redismock.NewClientMock()
	defer db.Close()

	mock.ExpectIncr("https://example.com/url").SetVal(42)
	ctx := context.Background()
	val, err := db.Incr(ctx, "https://example.com/url").Result()
	assert.NoError(t, err)
	assert.Equal(t, int64(42), val)
	assert.NoError(t, mock.ExpectationsWereMet())
}
