# Docker Setup for Spotify MCP Server

This document provides a quick reference for running the Spotify MCP Server in Docker.

## Files Added

- **Dockerfile** - Multi-stage build with Node.js 20 Alpine, security-focused with non-root user, handles missing package-lock.json gracefully
- **.dockerignore** - Excludes unnecessary files from Docker build context
- **docker-compose.yml** - Easy orchestration with volume mounting for config
- **docker-build.sh** - Convenience script for building the Docker image
- **DOCKER_SETUP.md** - This documentation file

## Quick Start

### 1. Build the Image
```bash
# Option A: Use the build script
./docker-build.sh

# Option B: Manual build
docker build -t spotify-mcp-server .

# Option C: Using docker-compose
docker-compose build
```

### 2. Set up Spotify Configuration
Ensure you have `spotify-config.json` with your Spotify API credentials:

```json
{
  "clientId": "your-client-id",
  "clientSecret": "your-client-secret",
  "redirectUri": "http://127.0.0.1:8888/callback"
}
```

### 3. Authenticate (First Time Only)
```bash
# Run authentication in container
docker run --rm -it -v $(pwd)/spotify-config.json:/app/spotify-config.json:rw -p 8888:8888 spotify-mcp-server npm run auth

# Or with docker-compose
docker-compose run --rm --service-ports spotify-mcp npm run auth
```

### 4. Run the Server
```bash
# Option A: Docker run
docker run -d --name spotify-mcp -v $(pwd)/spotify-config.json:/app/spotify-config.json:ro -p 8888:8888 spotify-mcp-server

# Option B: Docker Compose (recommended)
docker-compose up -d
```

## Docker Image Features

- **Base Image**: Node.js 20 Alpine (compact and secure)
- **Multi-stage build**: Installs dev dependencies, builds TypeScript, then cleans up
- **Security**: Runs as non-root user (nodejs:nodejs)
- **Health Check**: Built-in health monitoring
- **Port Exposure**: Port 8888 for OAuth callbacks
- **Volume Support**: Mounts config file for persistent authentication

## Integration with MCP Clients

### Claude Desktop
```json
{
  "mcpServers": {
    "spotify": {
      "command": "docker",
      "args": ["run", "--rm", "-v", "$(pwd)/spotify-config.json:/app/spotify-config.json:ro", "spotify-mcp-server"]
    }
  }
}
```

### Cursor
```bash
docker run --rm -v $(pwd)/spotify-config.json:/app/spotify-config.json:ro spotify-mcp-server
```

## Troubleshooting

- **OAuth Callback Issues**: Use `--network=host` for Docker run commands
- **Config File Not Found**: Ensure the volume mount path is correct
- **Permission Issues**: Check that spotify-config.json is readable
- **Port Conflicts**: Change the host port mapping if 8888 is in use

## Logs and Debugging

```bash
# View logs
docker logs spotify-mcp
# or with docker-compose
docker-compose logs -f

# Interactive shell in container
docker exec -it spotify-mcp /bin/sh
```
