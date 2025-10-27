# Week 3 – User Management & Processes

## 1. User and Group Management
- `whoami` → current user
- `id` → view UID, GID, groups
- `sudo adduser testuser` → create user
- `sudo groupadd testgroup` → create group
- `sudo usermod -aG testgroup testuser` → add user to group
- `cat /etc/passwd`, `cat /etc/group` → view system user/group info

## 2. Switching Users & Privileges
- `su - testuser` → switch to user
- `sudo -l` → list sudo privileges
- `sudo visudo` → safely edit sudoers

## 3. Process Management
- `ps aux` → list processes
- `top` or `htop` → monitor running processes
- `kill <pid>` → terminate process
- `pkill <process_name>` → kill by name

## 4. Job Control
- `sleep 100 &` → run background job
- `jobs` → list background jobs
- `fg`, `bg` → bring jobs to foreground/background

## 5. System Monitoring
- `uptime` → system uptime
- `df -h` → disk usage
- `free -h` → memory usage
- `vmstat`, `lsof` → monitor processes & open files

Artifacts are stored in `artifacts/` folder.
