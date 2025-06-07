#!/bin/zsh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "${BLUE}🚀 Starting Educational Platform Production Environment...${NC}"

# Check if .env file exists
if [ ! -f .env ]; then
    echo "${RED}❌ .env file not found. Please create one based on .env.example${NC}"
    exit 1
fi

# Load environment variables
export $(cat .env | grep -v '^#' | xargs)

# Build and start all services
echo "${BLUE}🏗️  Building and starting all services...${NC}"
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up --build -d

echo "${YELLOW}⏳ Waiting for services to be ready...${NC}"
sleep 30

echo "${GREEN}✅ Production environment is ready!${NC}"
echo ""
echo "${BLUE}📋 Production URLs:${NC}"
echo "   • Application: ${YELLOW}http://localhost${NC}"
echo "   • API: ${YELLOW}http://localhost:8080${NC}"
