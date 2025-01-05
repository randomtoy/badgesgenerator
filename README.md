# Visitors Badge Service

This project provides a simple web service that generates an SVG badge displaying the number of visits to a given URL. The service is built using Go, Redis, and the Echo framework, and it is containerized for easy deployment with Docker.

---

## Features
- Generates visitor badges in SVG format.
- Tracks and increments visit counts for specific URLs using Redis.
- Fully containerized for deployment using Docker and Docker Compose.

---

## Configuration
The application uses environment variables for configuration. Below are the configurable options:

| Environment Variable | Description                | Default Value |
|----------------------|----------------------------|---------------|
| `PORT`               | Port for the web server    | `8080`        |
| `REDIS_HOST`         | Redis server host          | `localhost`   |
| `REDIS_PORT`         | Redis server port          | `6379`        |
| `REDIS_PASSWORD`     | Redis server password      | *(empty)*     |

---

## Installation and Usage

### Running with Docker Compose
1. Clone this repository:
   ```bash
   git clone https://github.com/randomtoy/badgesgenerator.git
   cd badgesgenerator
   ```

2. Build and start the services:
   ```bash
   docker-compose up --build
   ```

3. Access the service at: 
   ```
   http://localhost:8080
   ```

---

## API Endpoint

### GET `/badge.svg`
Generates an SVG badge displaying the number of visits for a specified URL.

#### Query Parameters
- **`url`** (required): The URL for which the badge is generated.

#### Example Request
```bash
curl "http://localhost:8080/badge?url=https://example.com"
```

#### Example Response (SVG)
```xml
<svg xmlns="http://www.w3.org/2000/svg" ...>...</svg>
```

---

## Development

### Prerequisites
- Install **Go** (>= 1.23.2).
- Install **Redis**.

### Running Locally
1. Clone the repository:
   ```bash
   git clone https://github.com/randomtoy/badgesgenerator.git
   cd badgesgenerator
   ```

2. Start Redis locally:
   ```bash
   redis-server
   ```

3. Configure environment variables (optional):
   ```bash
   export PORT=8080
   export REDIS_HOST=localhost
   export REDIS_PORT=6379
   export REDIS_PASSWORD=
   ```

4. Start the application:
   ```bash
   go run main.go
   ```

5. Access the service at:
   ```
   http://localhost:8080
   ```

---

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

For any issues, feature requests, or contributions, please open an issue in the repository or contact the maintainer directly via email:randomtoy@gmail.com.

