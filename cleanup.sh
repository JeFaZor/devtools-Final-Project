#!/bin/bash

# ================================
# cleanup.sh - Complete system cleanup
# ================================

echo "Starting Complete Cleanup..."
echo "============================"

# Warning to user
read -p "WARNING: This will delete EVERYTHING! Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cleanup cancelled"
    exit 1
fi

# Stop containers
echo "Stopping containers..."
docker stop joomla-app mysql-joomla 2>/dev/null && echo "Containers stopped" || echo "Containers already stopped"

# Remove containers
echo "Removing containers..."
docker rm joomla-app mysql-joomla 2>/dev/null && echo "Containers removed" || echo "Containers already removed"

# Remove volumes
echo "Removing volumes..."
docker volume rm mysql_data joomla_data 2>/dev/null && echo "Volumes removed" || echo "Volumes already removed"

# Remove network
echo "Removing network..."
docker network rm joomla-network 2>/dev/null && echo "Network removed" || echo "Network already removed"

# Remove images (optional)
read -p "Remove Docker images too? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Removing images..."
    docker rmi joomla:latest mysql:8.0 2>/dev/null && echo "Images removed" || echo "Images already removed"
fi

# Remove backup files (optional)
read -p "Remove backup files too? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Removing backup files..."
    rm -f joomla_backup*.sql.gz
    rm -rf backup_files
    echo "Backup files removed"
fi

# Clean Docker system
echo "Cleaning Docker system..."
docker system prune -f

echo ""
echo "Cleanup Complete!"
echo "================"
echo "All containers removed"
echo "All volumes removed"  
echo "Network removed"
echo "System cleaned"
echo ""
echo "Run './setup.sh' to start fresh!"
