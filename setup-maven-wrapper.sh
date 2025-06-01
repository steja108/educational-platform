#!/bin/bash
# setup-maven-wrapper.sh
# Script to add Maven wrapper to all backend services

echo "Setting up Maven wrapper for all backend services..."

# Function to setup Maven wrapper for a service
setup_wrapper() {
    local service_dir=$1
    echo "Setting up Maven wrapper for $service_dir..."

    if [ -d "$service_dir" ]; then
        cd "$service_dir"

        # Remove existing wrapper files if they exist
        rm -f mvnw mvnw.cmd
        rm -rf .mvn

        # Generate new wrapper
        mvn wrapper:wrapper

        # Make mvnw executable
        chmod +x mvnw

        echo "Maven wrapper setup completed for $service_dir"
        cd - > /dev/null
    else
        echo "Directory $service_dir does not exist!"
    fi
}

# Setup wrapper for each backend service
setup_wrapper "backend/api-gateway"
setup_wrapper "backend/user-management-service"
setup_wrapper "backend/course-management-service"

echo "All Maven wrappers have been set up successfully!"

# Instructions for manual setup if needed
cat << 'EOF'

If the script fails, you can manually set up Maven wrapper for each service:

1. Navigate to each service directory:
   cd backend/api-gateway

2. Run Maven wrapper command:
   mvn wrapper:wrapper

3. Make the wrapper executable:
   chmod +x mvnw

4. Repeat for other services:
   - backend/user-management-service
   - backend/course-management-service

EOF