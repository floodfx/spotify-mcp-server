#!/bin/bash

# Build script for Spotify MCP Server Docker image

set -e

echo "Building Spotify MCP Server Docker image..."
docker build -t spotify-mcp-server .

echo "Docker image built successfully!"
echo "You can now run the server with:"
echo "  docker run -d --name spotify-mcp -v \$(pwd)/spotify-config.json:/app/spotify-config.json:ro -p 8888:8888 spotify-mcp-server"
echo ""
echo "Or use docker-compose:"
echo "  docker-compose up -d"
