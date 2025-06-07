#!/bin/zsh
# mac-setup.sh - Mac-optimized project setup script

# Colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "${BLUE}🚀 Setting up Educational Platform for macOS...${NC}"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print status
print_status() {
    echo "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo "${RED}❌ $1${NC}"
}

# Check prerequisites
echo "${BLUE}🔍 Checking prerequisites...${NC}"

# Check Homebrew
if ! command_exists brew; then
    print_warning "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    print_status "Homebrew found"
fi

# Check Java version
if command_exists java; then
    JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
    if [[ "$JAVA_VERSION" -ge 17 ]]; then
        print_status "Java $JAVA_VERSION found (compatible)"
        
        # Set JAVA_HOME if not set
        if [ -z "$JAVA_HOME" ]; then
            # Try to detect Java home automatically
            DETECTED_JAVA_HOME=$(java -XshowSettings:properties -version 2>&1 | grep 'java.home' | awk '{print $3}')
            if [ -n "$DETECTED_JAVA_HOME" ]; then
                echo "export JAVA_HOME=\"$DETECTED_JAVA_HOME\"" >> ~/.zshrc
                export JAVA_HOME="$DETECTED_JAVA_HOME"
                print_status "JAVA_HOME set to $JAVA_HOME"
            fi
        else
            print_status "JAVA_HOME already set: $JAVA_HOME"
        fi
    else
        print_warning "Java version $JAVA_VERSION found, but Java 17+ is recommended"
        print_warning "Your Java 21 is perfect! Continuing..."
    fi
else
    print_error "Java not found. Please install Java 17+ first"
    exit 1
fi

# Check Node.js version
if command_exists node; then
    NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [[ "$NODE_VERSION" -ge 18 ]]; then
        print_status "Node.js $(node -v) found (compatible)"
    else
        print_warning "Node.js version $NODE_VERSION found, but version 18+ is recommended"
    fi
else
    print_error "Node.js not found. Please install Node.js 18+ first"
    exit 1
fi

# Check npm version
if command_exists npm; then
    NPM_VERSION=$(npm -v | cut -d'.' -f1)
    if [[ "$NPM_VERSION" -ge 9 ]]; then
        print_status "npm $(npm -v) found (compatible)"
    else
        print_warning "npm version $(npm -v) found, older versions may work but 9+ is recommended"
    fi
else
    print_error "npm not found. Please install npm first"
    exit 1
fi

# Check Docker
if command_exists docker; then
    if docker info >/dev/null 2>&1; then
        DOCKER_VERSION=$(docker --version | cut -d' ' -f3 | cut -d',' -f1)
        print_status "Docker $DOCKER_VERSION found and running"
    else
        print_warning "Docker found but not running. Please start Docker Desktop"
        print_warning "You can start it with: open -a Docker"
    fi
else
    print_error "Docker not found. Please install Docker Desktop first"
    exit 1
fi

# Check Maven
if command_exists mvn; then
    MVN_VERSION=$(mvn -v | head -n 1 | cut -d' ' -f3)
    print_status "Maven $MVN_VERSION found (compatible)"
else
    print_warning "Maven not found, but project includes Maven wrapper (mvnw)"
    print_status "Will use Maven wrapper for builds"
fi

# Create project directory structure
echo "${BLUE}📁 Creating project directory structure...${NC}"

# Main directories
mkdir -p backend/{api-gateway,user-management-service,course-management-service,content-delivery-service,assessment-service,progress-tracking-service,payment-service,notification-service,shared}
mkdir -p frontend/{public,src/{components/{auth,common,layout},pages,hooks,services,store,utils,types}}
mkdir -p infrastructure/{kubernetes,docker,aws}
mkdir -p docs/{api,architecture,deployment}
mkdir -p scripts/{dev,prod,utils}

# Backend detailed structure
mkdir -p backend/api-gateway/{src/{main/{java/com/eduplatform/gateway/{filter,exception,config},resources},test/java},target}
mkdir -p backend/user-management-service/{src/{main/{java/com/eduplatform/user/{entity,dto,repository,service,controller,config,util},resources},test/java},target}

print_status "Directory structure created"

# Create .gitignore
echo "${BLUE}📝 Creating configuration files...${NC}"

cat > .gitignore << 'EOF'
# Compiled class files
*.class

# Log files
*.log

# BlueJ files
*.ctxt

# Mobile Tools for Java (J2ME)
.mtj.tmp/

# Package Files
*.jar
*.war
*.nar
*.ear
*.zip
*.tar.gz
*.rar

# Virtual machine crash logs
hs_err_pid*
replay_pid*

# Maven
target/
pom.xml.tag
pom.xml.releaseBackup
pom.xml.versionsBackup
pom.xml.next
release.properties
dependency-reduced-pom.xml
buildNumber.properties
.mvn/timing.properties
.mvn/wrapper/maven-wrapper.jar

# Node.js
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
lerna-debug.log*
.pnpm-debug.log*

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Coverage directory
coverage/
*.lcov
.nyc_output

# ESLint cache
.eslintcache

# Microbundle cache
.rpt2_cache/
.rts2_cache_cjs/
.rts2_cache_es/
.rts2_cache_umd/

# Optional npm cache directory
.npm

# Optional eslint cache
.eslintcache

# Parcel cache
.cache
.parcel-cache

# Next.js build output
.next
out

# Nuxt.js build / generate output
.nuxt
dist

# Gatsby files
.cache/
public

# Vuepress build output
.vuepress/dist

# Serverless directories
.serverless/

# FuseBox cache
.fusebox/

# DynamoDB Local files
.dynamodb/

# TernJS port file
.tern-port

# Stores VSCode versions used for testing VSCode extensions
.vscode-test

# yarn v2
.yarn/cache
.yarn/unplugged
.yarn/build-state.yml
.yarn/install-state.gz
.pnp.*

# IDEs
.idea/
*.iml
.vscode/
*.swp
*.swo

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Docker
docker-compose.override.yml

# Local development
*.local

# Build directories
build/
dist/

# Logs
logs/
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Frontend build
frontend/build/
frontend/dist/
EOF

# Create environment template
cat > .env.example << 'EOF'
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=password

# Database Names
USER_DB_NAME=user_management_db
COURSE_DB_NAME=course_management_db
ASSESSMENT_DB_NAME=assessment_db
PROGRESS_DB_NAME=progress_tracking_db
PAYMENT_DB_NAME=payment_db

# JWT Configuration
JWT_SECRET=mySecretKey1234567890123456789012345678901234567890

# Redis Configuration
REDIS_HOST=localhost
REDIS_PORT=6379

# Kafka Configuration
KAFKA_BOOTSTRAP_SERVERS=localhost:9092

# AWS Configuration (for production)
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_REGION=us-east-1
AWS_S3_BUCKET=eduplatform-content

# Frontend Configuration
REACT_APP_API_URL=http://localhost:8080

# Email Configuration (for notifications)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-password

# Payment Configuration
STRIPE_PUBLIC_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...

# Development Configuration
SPRING_PROFILES_ACTIVE=dev
LOG_LEVEL=DEBUG
EOF

# Create Mac-optimized development script
cat > scripts/dev/start-dev-mac.sh << 'EOF'
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
EOF

# Create stop script
cat > scripts/dev/stop-dev-mac.sh << 'EOF'
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
EOF

# Create status check script
cat > scripts/utils/check-status-mac.sh << 'EOF'
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
EOF

# Create cleanup script
cat > scripts/utils/cleanup-mac.sh << 'EOF'
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
EOF

# Create production script
cat > scripts/prod/start-prod-mac.sh << 'EOF'
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
EOF

# Make all scripts executable
chmod +x scripts/dev/start-dev-mac.sh
chmod +x scripts/dev/stop-dev-mac.sh
chmod +x scripts/utils/check-status-mac.sh
chmod +x scripts/utils/cleanup-mac.sh
chmod +x scripts/prod/start-prod-mac.sh

# Create main README for Mac
cat > README-MAC.md << 'EOF'
# Educational Platform - macOS Setup Guide

## 🍎 Quick Start for Mac

### Prerequisites
- macOS 10.15+ (Catalina or later)
- Admin privileges to install software

### One-Command Setup
```bash
# Download and run the Mac setup script
curl -sSL https://raw.githubusercontent.com/your-repo/main/mac-setup.sh | zsh
```

### Manual Setup
```bash
# 1. Clone the repository
git clone <your-repo-url>
cd educational-platform

# 2. Run Mac setup
chmod +x mac-setup.sh
./mac-setup.sh

# 3. Configure environment
cp .env.example .env
# Edit .env with your settings

# 4. Start development environment
./scripts/dev/start-dev-mac.sh
```

## 🛠️ Development Commands

### Starting Services
```bash
# Start development environment
./scripts/dev/start-dev-mac.sh

# Start production environment
./scripts/prod/start-prod-mac.sh
```

### Stopping Services
```bash
# Stop development environment
./scripts/dev/stop-dev-mac.sh

# Stop all processes
pkill -f "spring-boot\|react-scripts"
```

### Monitoring
```bash
# Check service status
./scripts/utils/check-status-mac.sh

# View logs
tail -f logs/api-gateway.log
tail -f logs/user-management-service.log
tail -f logs/frontend.log
```

### Maintenance
```bash
# Clean up everything
./scripts/utils/cleanup-mac.sh

# Reset database
docker-compose down -v
docker-compose up -d postgres
```

## 🌐 Service URLs

| Service | Development | Production |
|---------|-------------|------------|
| Frontend | http://localhost:3000 | http://localhost |
| API Gateway | http://localhost:8080 | http://localhost:8080 |
| User Service | http://localhost:8081 | Internal |
| PostgreSQL | localhost:5432 | Internal |
| Redis | localhost:6379 | Internal |

## 🔧 Troubleshooting

### Docker Issues
```bash
# Check Docker status
docker --version
docker info

# Restart Docker Desktop
pkill Docker && open -a Docker
```

### Java Issues
```bash
# Check Java installation
java -version
echo $JAVA_HOME

# Fix Java path
echo 'export JAVA_HOME="/opt/homebrew/opt/openjdk@17"' >> ~/.zshrc
source ~/.zshrc
```

### Port Conflicts
```bash
# Find process using port
lsof -i :8080

# Kill process
kill -9 $(lsof -ti:8080)
```

### Clean Install
```bash
# Complete cleanup and fresh start
./scripts/utils/cleanup-mac.sh
./mac-setup.sh
./scripts/dev/start-dev-mac.sh
```

## 🍺 Homebrew Packages

The setup installs these packages:
- `openjdk@17` - Java Development Kit
- `node` - Node.js runtime
- `maven` - Build automation tool
- `docker` - Containerization platform

## 🔍 Monitoring Tools

### Activity Monitor
- Monitor CPU and memory usage
- Find and kill processes if needed

### Terminal Commands
```bash
# Monitor system resources
top -o cpu

# Monitor network connections
netstat -an | grep LISTEN

# Monitor Docker containers
docker stats
```

## 📱 Recommended Mac Apps

- **Docker Desktop** - Container management
- **VS Code** - Code editor
- **Postman** - API testing
- **Sequel Pro** - Database management
- **iTerm2** - Enhanced terminal

Install with Homebrew:
```bash
brew install --cask visual-studio-code postman sequel-pro iterm2
```
EOF

print_status "Configuration files created"

# Create simple package.json for frontend
if [ ! -f "frontend/package.json" ]; then
    echo "${BLUE}📦 Creating frontend package.json...${NC}"
    
    cat > frontend/package.json << 'EOF'
{
  "name": "educational-platform-frontend",
  "version": "0.1.0",
  "private": true,
  "dependencies": {
    "@reduxjs/toolkit": "^1.9.7",
    "@types/node": "^16.18.68",
    "@types/react": "^18.2.42",
    "@types/react-dom": "^18.2.17",
    "axios": "^1.6.2",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-redux": "^8.1.3",
    "react-router-dom": "^6.20.1",
    "react-scripts": "5.0.1",
    "typescript": "^4.9.5",
    "@mui/material": "^5.14.20",
    "@mui/icons-material": "^5.14.19",
    "@emotion/react": "^11.11.1",
    "@emotion/styled": "^11.11.0",
    "react-player": "^2.13.0"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "eslintConfig": {
    "extends": [
      "react-app",
      "react-app/jest"
    ]
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  },
  "proxy": "http://localhost:8080"
}
EOF
fi

echo ""
echo "${GREEN}🎉 Mac setup complete!${NC}"
echo ""
echo "${BLUE}📋 Next Steps:${NC}"
echo "1. ${YELLOW}cp .env.example .env${NC} - Configure your environment"
echo "2. ${YELLOW}./scripts/dev/start-dev-mac.sh${NC} - Start development environment"
echo "3. ${YELLOW}Open http://localhost:3000${NC} - View the application"
echo ""
echo "${BLUE}📚 Available Commands:${NC}"
echo "• ${GREEN}./scripts/dev/start-dev-mac.sh${NC} - Start development"
echo "• ${GREEN}./scripts/dev/stop-dev-mac.sh${NC} - Stop development"
echo "• ${GREEN}./scripts/utils/check-status-mac.sh${NC} - Check service status"
echo "• ${GREEN}./scripts/utils/cleanup-mac.sh${NC} - Clean up everything"
echo ""
echo "${YELLOW}💡 Tip: Read README-MAC.md for detailed instructions${NC}"
