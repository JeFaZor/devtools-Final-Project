#!/bin/bash

# ================================
# backup.sh - Database backup with Git integration
# ================================

echo "Starting Joomla Backup..."
echo "========================="

# Check if MySQL container is running
if ! docker ps | grep -q mysql-joomla; then
    echo "ERROR: MySQL container is not running!"
    exit 1
fi

# Create database backup
echo "Creating database backup..."
BACKUP_FILE="joomla_backup_$(date +%Y%m%d_%H%M%S).sql.gz"

docker exec mysql-joomla sh -c 'exec mysqldump --all-databases -uroot -p$MYSQL_ROOT_PASSWORD' | gzip > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "Database backup created: $BACKUP_FILE"
else
    echo "ERROR: Database backup failed!"
    exit 1
fi

# Create current backup file
cp "$BACKUP_FILE" "joomla_backup.sql.gz"
echo "Current backup updated: joomla_backup.sql.gz"

# Backup Joomla files
echo "Backing up Joomla files..."
if docker volume ls | grep -q joomla_data; then
    mkdir -p backup_files
    docker run --rm -v joomla_data:/source -v "$(pwd)/backup_files":/backup alpine tar czf /backup/joomla_files.tar.gz -C /source .
    echo "Joomla files backed up"
fi

# Git operations
echo "Saving to Git..."
git add .
git commit -m "Backup: $(date '+%Y-%m-%d %H:%M:%S') - Database and files updated"

if git push; then
    echo "Backup pushed to Git repository"
else
    echo "WARNING: Git push failed (no remote configured?)"
fi

echo ""
echo "Backup Complete!"
echo "================"
echo "Latest backup: $BACKUP_FILE"
echo "Current backup: joomla_backup.sql.gz"
