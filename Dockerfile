FROM golang:1.23.2-alpine as builder

WORKDIR /app

COPY go.mod go.sum /app/
RUN go mod download

COPY cmd /app/cmd
COPY internal /app/internal
RUN go build -C cmd/ -o app

FROM --platform=amd64 alpine:latest

WORKDIR /app

COPY --from=builder /app/cmd/app .

EXPOSE 8080

CMD ["./app"]