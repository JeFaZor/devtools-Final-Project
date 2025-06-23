#!/bin/bash

# ================================
# restore.sh - Restore from backup
# ================================

BACKUP_FILE=${1:-"joomla_backup.sql.gz"}

echo "Starting Joomla Restore..."
echo "=========================="

# Check if backup file exists
if [ ! -f "$BACKUP_FILE" ]; then
    echo "ERROR: Backup file '$BACKUP_FILE' not found!"
    echo "Usage: ./restore.sh [backup_file.sql.gz]"
    exit 1
fi

# Check if MySQL container is running
if ! docker ps | grep -q mysql-joomla; then
    echo "ERROR: MySQL container is not running! Run ./setup.sh first"
    exit 1
fi

echo "Using backup file: $BACKUP_FILE"

# Wait for MySQL to be ready
echo "Waiting for MySQL to be ready..."
sleep 10

# Restore database
echo "Restoring database..."
gunzip < "$BACKUP_FILE" | docker exec -i mysql-joomla sh -c "exec mysql -uroot -pmy-secret-pw"

if [ $? -eq 0 ]; then
    echo "Database restored successfully"
else
    echo "ERROR: Database restore failed!"
    exit 1
fi

# Restore Joomla files
if [ -f "backup_files/joomla_files.tar.gz" ]; then
    echo "Restoring Joomla files..."
    docker run --rm -v joomla_data:/target -v $(pwd)/backup_files:/backup alpine tar xzf /backup/joomla_files.tar.gz -C /target
    echo "Joomla files restored"
fi

# Restart Joomla container
echo "Restarting Joomla container..."
docker restart joomla-app
sleep 10

# Get server IP
SERVER_IP=$(hostname -I | awk '{print $1}')

echo ""
echo "Restore Complete!"
echo "================"
echo "Site: http://$SERVER_IP:8080"
echo "Admin: http://$SERVER_IP:8080/administrator"
echo "Login: demoadmin / secretpassword"
