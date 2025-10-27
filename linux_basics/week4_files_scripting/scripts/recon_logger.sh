#!/usr/bin/env bash
set -euo pipefail

OUTDIR="$(dirname "$0")/../artifacts"
mkdir -p "$OUTDIR"
NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)
HOSTNAME=$(hostname -f 2>/dev/null || hostname)
IP_ADDR=$(hostname -I | awk '{print $1}')
UPTIME=$(uptime -p 2>/dev/null || echo "n/a")
OS_INFO=$(uname -a | sed 's/"/\\"/g')

# basic ports (top common ports)
PORTS=(22 80 443 3306 3000 8080)

# build JSON
echo -n "{" > "$OUTDIR/results.json"
echo -n "\"collected_at\":\"$NOW\"," >> "$OUTDIR/results.json"
echo -n "\"host\":\"$HOSTNAME\"," >> "$OUTDIR/results.json"
echo -n "\"ip\":\"$IP_ADDR\"," >> "$OUTDIR/results.json"
echo -n "\"uptime\":\"$UPTIME\"," >> "$OUTDIR/results.json"
echo -n "\"os\":\"$OS_INFO\"," >> "$OUTDIR/results.json"
echo -n "\"ports\":[" >> "$OUTDIR/results.json"
first=true
for p in "${PORTS[@]}"; do
  if nc -z -w1 127.0.0.1 $p >/dev/null 2>&1; then
    state="open"
  else
    state="closed"
  fi
  if [ "$first" = true ]; then first=false; else echo -n "," >> "$OUTDIR/results.json"; fi
  echo -n "{\"port\":$p,\"state\":\"$state\"}" >> "$OUTDIR/results.json"
done
echo -n "]," >> "$OUTDIR/results.json"

# collect small file list and sizes in /tmp (safe)
echo -n "\"tmp_files\":[" >> "$OUTDIR/results.json"
first=true
while IFS= read -r -d '' f; do
  sz=$(stat -c%s "$f" 2>/dev/null || echo 0)
  if [ "$first" = true ]; then first=false; else echo -n "," >> "$OUTDIR/results.json"; fi
  echo -n "{\"path\":\"$(echo "$f" | sed 's/\\/\\\\/g')\",\"size\":$sz}" >> "$OUTDIR/results.json"
done < <(find /tmp -maxdepth 2 -type f -print0 2>/dev/null)
echo -n "]" >> "$OUTDIR/results.json"

echo "}" >> "$OUTDIR/results.json"
echo "Saved: $OUTDIR/results.json"
