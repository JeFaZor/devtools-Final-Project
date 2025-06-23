#!/bin/bash

# ================================
# setup.sh - Complete Joomla Docker Setup
# ================================

echo "Starting Joomla Docker Setup..."
echo "================================"

# Create Docker network
echo "Creating Docker network..."
docker network create joomla-network 2>/dev/null && echo "Network 'joomla-network' created" || echo "Network already exists"

# Pull Docker images
echo "Pulling Docker images..."
docker pull mysql:8.0
docker pull joomla:latest

# Setup MySQL Container
echo "Setting up MySQL container..."
docker run -d \
  --name mysql-joomla \
  --network joomla-network \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=my-secret-pw \
  -e MYSQL_DATABASE=joomla_db \
  -e MYSQL_USER=joomla_user \
  -e MYSQL_PASSWORD=my-secret-pw \
  -v mysql_data:/var/lib/mysql \
  mysql:8.0

# Wait for MySQL to start
echo "Waiting for MySQL to start..."
sleep 30

# Setup Joomla Container  
echo "Setting up Joomla container..."
docker run -d \
  --name joomla-app \
  --network joomla-network \
  -p 8080:80 \
  -e JOOMLA_DB_HOST=mysql-joomla \
  -e JOOMLA_DB_USER=joomla_user \
  -e JOOMLA_DB_PASSWORD=my-secret-pw \
  -e JOOMLA_DB_NAME=joomla_db \
  -v joomla_data:/var/www/html \
  joomla:latest

# Wait for Joomla to start
echo "Waiting for Joomla to start..."
sleep 20

# Check container status
echo "Checking container status..."
docker ps

# Restore backup if exists
if [ -f "joomla_backup.sql.gz" ]; then
    echo "Found backup file, restoring..."
    ./restore.sh joomla_backup.sql.gz
fi

# Get server IP
SERVER_IP=$(hostname -I | awk '{print $1}')

echo ""
echo "Setup Complete!"
echo "================================"
echo "Joomla Site: http://$SERVER_IP:8080"
echo "Admin Panel: http://$SERVER_IP:8080/administrator"
echo ""
echo "Admin Login:"
echo "   Username: demoadmin"
echo "   Password: secretpassword"
echo "================================"
