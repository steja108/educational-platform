#!/bin/zsh

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "${BLUE}📊 Educational Platform Status Check${NC}"
echo ""

# Function to check service status
check_service() {
    local service_name=$1
    local url=$2
    local port=$3
    
    if curl -s "$url" >/dev/null 2>&1; then
        echo "${GREEN}✅ $service_name${NC} - Running on port $port"
    else
        echo "${RED}❌ $service_name${NC} - Not responding on port $port"
    fi
}

# Function to check port
check_port() {
    local service_name=$1
    local port=$2
    
    if lsof -i :$port >/dev/null 2>&1; then
        echo "${GREEN}✅ $service_name${NC} - Port $port is open"
    else
        echo "${RED}❌ $service_name${NC} - Port $port is not open"
    fi
}

echo "${BLUE}🌐 Web Services:${NC}"
check_service "Frontend" "http://localhost:3000" "3000"
check_service "API Gateway" "http://localhost:8080/actuator/health" "8080"
check_service "User Service" "http://localhost:8081/actuator/health" "8081"

echo ""
echo "${BLUE}🗄️  Infrastructure:${NC}"
check_port "PostgreSQL" "5432"
check_port "Redis" "6379"
check_port "Kafka" "9092"

echo ""
echo "${BLUE}🐳 Docker Status:${NC}"
if docker info >/dev/null 2>&1; then
    echo "${GREEN}✅ Docker${NC} - Running"
    
    # Check Docker containers
    running_containers=$(docker ps --format "table {{.Names}}\t{{.Status}}" | grep eduplatform | wc -l)
    if [ "$running_containers" -gt 0 ]; then
        echo "${GREEN}✅ Docker Containers${NC} - $running_containers running"
        docker ps --format "table {{.Names}}\t{{.Status}}" | grep eduplatform
    else
        echo "${YELLOW}⚠️  Docker Containers${NC} - None running"
    fi
else
    echo "${RED}❌ Docker${NC} - Not running"
fi

echo ""
echo "${BLUE}💾 Processes:${NC}"
java_processes=$(pgrep -f "spring-boot:run" | wc -l)
node_processes=$(pgrep -f "react-scripts" | wc -l)

echo "Java processes: $java_processes"
echo "Node processes: $node_processes"
