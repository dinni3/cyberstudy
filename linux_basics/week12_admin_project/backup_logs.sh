#!/bin/bash
LOG_SRC="/var/log"
BACKUP_DIR="$HOME/lab/linux_basics/week12_admin_project/artifacts/log_backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/logs_$TIMESTAMP.tar.gz" $LOG_SRC 2>/dev/null

# Keep only last 3 backups
cd "$BACKUP_DIR" && ls -tp | grep -v '/$' | tail -n +4 | xargs -I {} rm -- {}

echo "Backup completed at $TIMESTAMP"
