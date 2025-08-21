#!/bin/bash

echo "Testing Docker build for Spotify MCP Server..."

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed"
    exit 1
fi

# Check if Docker daemon is running
if ! docker info &> /dev/null; then
    echo "❌ Docker daemon is not running"
    exit 1
fi

echo "✓ Docker is available and running"

# Test build
echo "Building Docker image..."
if docker build -t spotify-mcp-server .; then
    echo "✓ Docker build successful!"
    
    # Test image was created
    if docker images spotify-mcp-server -q &> /dev/null; then
        echo "✓ Docker image created successfully"
        
        # Get image size
        SIZE=$(docker images spotify-mcp-server --format "{{.Size}}")
        echo "📦 Image size: $SIZE"
        
        echo ""
        echo "🎉 Docker setup is working correctly!"
        echo "You can now run: docker-compose up -d"
    else
        echo "❌ Docker image was not created properly"
        exit 1
    fi
else
    echo "❌ Docker build failed"
    exit 1
fi
