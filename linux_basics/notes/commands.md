# Linux Commands Cheat Sheet (Week 1)

Examples and notes:
- ls -la : list files with permissions
- pwd : print working directory
- cat file.txt : print file contents
- head -n 20 file : show top of file
- tail -n 20 file : show end of file
- grep -Ri "pattern" file : search recursively (case-insensitive)
- find . -type f -name '*.txt' : find files by pattern
- chmod 755 file : set permissions
- chown $USER:$USER file : change owner to current user
- ps aux | grep process : show processes
- ss -tulpn : show listening sockets
- curl -I http://127.0.0.1:3000 : fetch headers
- tar -czf archive.tar.gz folder : archive

Keep this file updated as you learn.

## Week 4 quick refs
- find / -type f -name 'juiceshop.sqlite'  # find files by name
- locate filename  # fast DB-based lookup; run `sudo updatedb` first
- xargs -I{} cp {} /tmp/backup/  # run cmd on list of paths
- tar -czf backup.tgz folder/
- sha256sum file > file.sha256
- crontab -e  # edit user's cron jobs
- (bash) use `set -euo pipefail` at top of scripts for safety
