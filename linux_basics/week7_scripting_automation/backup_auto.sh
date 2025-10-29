#!/bin/bash
# backup_auto.sh – simple backup script

SRC="$1"
DST_DIR="$HOME/lab/linux_basics/week7_scripting_automation/artifacts"
TS=$(date +"%Y%m%d_%H%M%S")
ARCHIVE="$DST_DIR/backup_${TS}.tgz"

if [ -z "$SRC" ]; then
  echo "Usage: $0 <source_folder>"
  exit 1
fi

tar -czf "$ARCHIVE" -C "$(dirname "$SRC")" "$(basename "$SRC")"
sha256sum "$ARCHIVE" > "${ARCHIVE}.sha256"
echo "Backup created: $ARCHIVE"
