#!/bin/bash
# net_scan_logger.sh – ping sweep logger

NET="192.168.0"
OUT="$HOME/lab/linux_basics/week7_scripting_automation/artifacts/net_alive.txt"

echo "Scan started at $(date)" > "$OUT"

for i in $(seq 1 10); do
  ping -c 1 -W 1 ${NET}.${i} &>/dev/null && echo "${NET}.${i} alive" >> "$OUT"
done

echo "Scan completed at $(date)" >> "$OUT"
