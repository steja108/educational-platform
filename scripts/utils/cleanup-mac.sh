#!/bin/zsh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "${BLUE}🧹 Cleaning up Educational Platform...${NC}"

# Stop all services first
echo "${YELLOW}🛑 Stopping all services...${NC}"
./scripts/dev/stop-dev-mac.sh

# Clean Docker
echo "${YELLOW}🐳 Cleaning Docker resources...${NC}"
docker-compose down -v --remove-orphans
docker system prune -f

# Clean Maven builds
echo "${YELLOW}☕ Cleaning Maven builds...${NC}"
find backend -name "target" -type d -exec rm -rf {} + 2>/dev/null || true

# Clean Node.js builds
echo "${YELLOW}⚛️  Cleaning Node.js builds...${NC}"
find frontend -name "node_modules" -type d -exec rm -rf {} + 2>/dev/null || true
find frontend -name "build" -type d -exec rm -rf {} + 2>/dev/null || true

# Clean logs
echo "${YELLOW}📝 Cleaning logs...${NC}"
rm -rf logs/*

echo "${GREEN}✅ Cleanup complete!${NC}"
