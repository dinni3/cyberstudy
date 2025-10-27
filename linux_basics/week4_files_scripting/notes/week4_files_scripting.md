# Week 4 — File Systems & Scripting

Topics covered:
- Searching & locating files: find, locate, updatedb
- Efficient text processing: xargs, grep, sed, awk
- Archiving & compression: tar, gzip, zip
- Backups & checksum: sha256sum
- Log parsing basics and rotating logs
- Cron basics and scheduling jobs
- Bash scripting best practices and a tiny python scanner sample

Artifacts: results.json, port_scan.csv, sample_archives/*.tar.gz


## Archiving & Checksums
- tar -czf archive.tgz folder/  # create gzipped tar
- sha256sum file > file.sha256  # produce checksum to verify integrity

## Searching Examples
- locate filename  # fast DB backed search (updatedb updates DB)
- find . -type f -name '*.txt'  # manual recursive search
- xargs - run commands on lists of files (be careful with spaces/newlines)


## Cron example (documentation)
# run recon_logger.sh at 0 * * * * (hourly) - to edit crontab:
# crontab -e
# Example line:
# 0 * * * * /home/$(whoami)/lab/linux_basics/week4_files_scripting/scripts/recon_logger.sh >/dev/null 2>&1

