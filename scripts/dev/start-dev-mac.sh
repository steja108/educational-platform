#!/bin/zsh

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "${BLUE}🚀 Starting Educational Platform Development Environment (macOS)...${NC}"

# Check if Docker Desktop is running
if ! docker info >/dev/null 2>&1; then
    echo "${RED}❌ Docker is not running.${NC}"
    echo "${YELLOW}Please start Docker Desktop and try again.${NC}"
    echo "You can start it from Applications or run: open -a Docker"
    exit 1
fi

# Check if .env file exists
if [ ! -f .env ]; then
    echo "${YELLOW}⚠️  .env file not found. Creating from template...${NC}"
    cp .env.example .env
    echo "${GREEN}✅ Created .env file. Please review and update the configuration.${NC}"
fi

# Load environment variables
export $(cat .env | grep -v '^#' | xargs)

# Start infrastructure services
echo "${BLUE}📦 Starting infrastructure services...${NC}"
docker-compose up -d postgres redis zookeeper kafka

echo "${YELLOW}⏳ Waiting for services to be ready...${NC}"
sleep 15

# Check if PostgreSQL is ready
echo "${BLUE}🔍 Checking database connectivity...${NC}"
max_attempts=30
attempt=1

while ! docker exec eduplatform-postgres pg_isready -U postgres >/dev/null 2>&1; do
    if [ $attempt -eq $max_attempts ]; then
        echo "${RED}❌ PostgreSQL failed to start after $max_attempts attempts${NC}"
        exit 1
    fi
    echo "Waiting for PostgreSQL... (attempt $attempt/$max_attempts)"
    sleep 2
    ((attempt++))
done

echo "${GREEN}✅ Infrastructure services are ready!${NC}"

# Function to start backend service
start_backend_service() {
    local service_name=$1
    local port=$2
    local service_path="backend/$service_name"
    
    if [ -d "$service_path" ]; then
        echo "${BLUE}🔧 Starting $service_name on port $port...${NC}"
        cd "$service_path"
        
        # Check if Maven wrapper exists
        if [ -f "./mvnw" ]; then
            ./mvnw spring-boot:run > "../../logs/${service_name}.log" 2>&1 &
        else
            mvn spring-boot:run > "../../logs/${service_name}.log" 2>&1 &
        fi
        
        cd - > /dev/null
        echo "${GREEN}✅ $service_name started${NC}"
    else
        echo "${YELLOW}⚠️  $service_name directory not found, skipping...${NC}"
    fi
}

# Create logs directory
mkdir -p logs

# Start backend services
echo "${BLUE}🔧 Starting backend services...${NC}"
start_backend_service "api-gateway" 8080
sleep 5
start_backend_service "user-management-service" 8081
sleep 5

# Start frontend
if [ -d "frontend" ]; then
    echo "${BLUE}🎨 Starting frontend...${NC}"
    cd frontend
    
    # Install dependencies if node_modules doesn't exist
    if [ ! -d "node_modules" ]; then
        echo "${YELLOW}📦 Installing frontend dependencies...${NC}"
        npm install
    fi
    
    # Start React development server
    npm start > ../logs/frontend.log 2>&1 &
    cd - > /dev/null
    echo "${GREEN}✅ Frontend started${NC}"
else
    echo "${YELLOW}⚠️  Frontend directory not found${NC}"
fi

echo ""
echo "${GREEN}🎉 Development environment is ready!${NC}"
echo ""
echo "${BLUE}📋 Service URLs:${NC}"
echo "   • Frontend: ${YELLOW}http://localhost:3000${NC}"
echo "   • API Gateway: ${YELLOW}http://localhost:8080${NC}"
echo "   • User Service: ${YELLOW}http://localhost:8081${NC}"
echo ""
echo "${BLUE}📊 Infrastructure:${NC}"
echo "   • PostgreSQL: ${YELLOW}localhost:5432${NC}"
echo "   • Redis: ${YELLOW}localhost:6379${NC}"
echo "   • Kafka: ${YELLOW}localhost:9092${NC}"
echo ""
echo "${BLUE}📝 Logs:${NC}"
echo "   • Backend logs: ${YELLOW}./logs/${NC}"
echo "   • Frontend logs: ${YELLOW}./logs/frontend.log${NC}"
echo ""
echo "${YELLOW}💡 Useful commands:${NC}"
echo "   • Stop all: ${BLUE}./scripts/dev/stop-dev-mac.sh${NC}"
echo "   • View logs: ${BLUE}tail -f logs/api-gateway.log${NC}"
echo "   • Check status: ${BLUE}./scripts/utils/check-status-mac.sh${NC}"
