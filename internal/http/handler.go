package http

import (
	"context"
	"net/http"

	"github.com/labstack/echo/v4"
	"github.com/randomtoy/badgesgenerator/internal/service"
	"github.com/randomtoy/badgesgenerator/internal/svg"
)

type Handler struct {
	visitorService *service.VisitorService
}

func NewHandler(visitorService *service.VisitorService) *Handler {
	return &Handler{visitorService: visitorService}
}

func (h *Handler) Badge(c echo.Context) error {
	ctx := context.Background()
	url := c.QueryParam("url")
	if url == "" {
		return echo.NewHTTPError(http.StatusBadRequest, "url is required")
	}

	count, err := h.visitorService.IncrementVisitorCounter(ctx, url)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	svgBadge := svg.GenerateBadgeSVG(count)
	return c.Blob(http.StatusOK, "image/svg+xml", []byte(svgBadge))
}

func StartServer(visitorService *service.VisitorService, port string) {
	e := echo.New()
	handler := NewHandler(visitorService)
	e.GET("/badge.svg", handler.Badge)
	e.Logger.Fatal(e.Start(":" + port))

}
