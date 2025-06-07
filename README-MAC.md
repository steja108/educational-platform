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
