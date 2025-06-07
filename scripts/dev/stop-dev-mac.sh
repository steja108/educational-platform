#!/bin/zsh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "${BLUE}🛑 Stopping Educational Platform Development Environment...${NC}"

# Stop Docker services
echo "${YELLOW}🐳 Stopping Docker services...${NC}"
docker-compose down

# Kill Java processes (Spring Boot apps)
echo "${YELLOW}☕ Stopping Java applications...${NC}"
pkill -f "spring-boot:run" 2>/dev/null || true
pkill -f "java.*eduplatform" 2>/dev/null || true

# Kill Node.js processes (React app)
echo "${YELLOW}⚛️  Stopping React application...${NC}"
pkill -f "react-scripts start" 2>/dev/null || true
pkill -f "node.*react-scripts" 2>/dev/null || true

# Wait a moment
sleep 2

echo "${GREEN}✅ All services stopped!${NC}"
