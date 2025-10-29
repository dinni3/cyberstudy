# Week 8 — Service Hardening & Security Basics

## Objectives
- Install and check UFW and Fail2Ban.
- Configure firewall rules (allow SSH, HTTP) and set safe defaults.
- Verify Fail2Ban SSH jail and service status.
- Inspect SSH configuration for common hardening options.

## Commands run (summary)
- sudo apt install ufw fail2ban
- sudo ufw allow 22/tcp
- sudo ufw default deny incoming
- sudo ufw default allow outgoing
- sudo ufw --force enable
- sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
- sudo systemctl restart fail2ban
- sudo cp /etc/ssh/sshd_config week8_security/artifacts/sshd_config_backup

## Artifacts
All outputs saved under `linux_basics/week8_security/artifacts/`:
- ufw_status_before.txt
- ufw_rules.txt
- ufw_status_after.txt
- fail2ban_status_before.txt
- fail2ban_ssh_section.txt
- fail2ban_status_after.txt
- fail2ban_journal_recent.txt
- sshd_config_backup
- ssh_security_settings.txt
- ss_tulpn_after_ufw.txt

## Notes / Safety
- If accessing the VM over SSH remotely, ensure "sudo ufw allow 22/tcp" (or your SSH port) is run before enabling UFW.
- Disabling PasswordAuthentication or PermitRootLogin should be tested carefully (you could lock out remote access).
- This lab is safe in a local VM but any production changes require planning and testing.

