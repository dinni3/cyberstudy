#!/usr/bin/env bash
set -euo pipefail

ROOT="$HOME/lab/juice-shop"
ARTDIR="$ROOT/artifacts"
IDOR="$ARTDIR/idor"
DB_COPY="$ROOT/db_inspect/juice_shop.db"
BACKUP_DIR="$ROOT/backup_2025-10-24"
TOKEN_FILE_RAW="$BACKUP_DIR/token_fresh.txt"
ADMIN_CSV="$IDOR/admin_users_redacted.csv"
WHOAMI_DB="$IDOR/whoami_db_admin.txt"
SUMMARY=()
echo
echo "=== Juice Shop cleanup & artifact generation script ==="
echo "(Working directory: $ROOT)"
echo

# Ensure artifact dir exists
mkdir -p "$IDOR"

# 1) Create redacted admin CSV from DB if DB exists
if [ -f "$DB_COPY" ]; then
  echo "[*] Creating redacted admin CSV at: $ADMIN_CSV"
  sqlite3 "$DB_COPY" <<'SQL' > "$ADMIN_CSV"
.headers on
.mode csv
SELECT id, COALESCE(username,'') AS username, email, role, isActive, createdAt FROM Users WHERE role='admin';
.quit
SQL
  SUMMARY+=("$ADMIN_CSV")
  echo "  -> saved: $(ls -lh "$ADMIN_CSV")"
else
  echo "[!] DB copy not found at $DB_COPY — skipping admin CSV creation"
fi

# 2) Save a whoami_db_admin.txt (non-sensitive selected columns)
if [ -f "$DB_COPY" ]; then
  echo "[*] Creating whoami DB summary at: $WHOAMI_DB"
  sqlite3 "$DB_COPY" <<'SQL' > "$WHOAMI_DB"
.headers on
.mode column
SELECT id, email, role, isActive, createdAt, updatedAt FROM Users WHERE role='admin';
.quit
SQL
  SUMMARY+=("$WHOAMI_DB")
  echo "  -> saved: $(ls -lh "$WHOAMI_DB")"
else
  echo "[!] DB copy not found at $DB_COPY — skipping whoami_db_admin creation"
fi

# 3) Redact JWT-like strings (non-destructive; creates .bak backups)
echo "[*] Redacting JWT-like tokens in $ARTDIR (creates .bak backups)"
shopt -s nullglob
FOUND_FILES=()
while IFS= read -r -d '' f; do
  FOUND_FILES+=("$f")
done < <(grep -RIl --exclude-dir=backup_* --exclude='*.bak' 'eyJ' "$ARTDIR" 2>/dev/null || true)

if [ ${#FOUND_FILES[@]} -eq 0 ]; then
  echo "  -> No JWT-like strings found in $ARTDIR"
else
  echo "  -> Files to redact: ${#FOUND_FILES[@]}"
  for f in "${FOUND_FILES[@]}"; do
    # use perl for robust in-place redaction across varied filenames
    perl -i.bak -pe 's/eyJ[A-Za-z0-9_\-]+\.[A-Za-z0-9_\-]+\.[A-Za-z0-9_\-]+/REDACTED_TOKEN/g' "$f" || true
    echo "   redacted: $f (backup saved as ${f}.bak)"
    SUMMARY+=("$f (redacted)")
  done
fi

# 4) Securely remove the local DB copy (if present)
if [ -f "$DB_COPY" ]; then
  echo "[*] Securely deleting local DB copy: $DB_COPY"
  if command -v shred >/dev/null 2>&1; then
    shred -u "$DB_COPY" 2>/dev/null || rm -f "$DB_COPY"
    echo "  -> shredded $DB_COPY"
  else
    rm -f "$DB_COPY"
    echo "  -> removed $DB_COPY (no shred available)"
  fi
else
  echo "  -> No local DB copy to remove"
fi

# 5) Remove raw token file(s)
if [ -f "$TOKEN_FILE_RAW" ]; then
  echo "[*] Securely removing raw token file: $TOKEN_FILE_RAW"
  if command -v shred >/dev/null 2>&1; then
    shred -u "$TOKEN_FILE_RAW" 2>/dev/null || rm -f "$TOKEN_FILE_RAW"
    echo "  -> shredded $TOKEN_FILE_RAW"
  else
    rm -f "$TOKEN_FILE_RAW"
    echo "  -> removed $TOKEN_FILE_RAW (no shred available)"
  fi
else
  echo "  -> No token file found at $TOKEN_FILE_RAW (ok)"
fi

# 6) Unset local shell variables (affects this script only; print instruction for user shell)
unset TOKEN || true
unset TOKEN_FRESH || true
echo
echo "Note: script unsets token variables in its own environment only."
echo "If you exported tokens in your interactive shell, run:"
echo "  unset TOKEN TOKEN_FRESH"
echo "to remove them from your current shell."
echo

# 7) Print artifact summary
echo "=== Artifact summary ==="
if [ ${#SUMMARY[@]} -eq 0 ]; then
  echo "No new artifacts created by this script."
else
  for item in "${SUMMARY[@]}"; do
    echo " - $item"
  done
fi

echo
echo "You can inspect the artifacts under: $IDOR"
echo "If you want to permanently delete backups (*.bak) produced by this script, run:"
echo "  find $ARTDIR -name '*.bak' -type f -print -delete"
echo
echo "Cleanup script completed."
