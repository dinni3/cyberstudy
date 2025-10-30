# TryHackMe — Pickle Rick (Room) — Writeup
**Target:** TryHackMe Pickle Rick room  
**Local mirror / artifacts:** `~/lab/tryhackme/artifacts/<IP>/`  
**Author:** dinnie  
**Date:** 2025-10-30  
**Reference walkthrough used:** https://whokilleddb.medium.com/tryhackme-pickle-rick-walkthrough-2c33bf07c77b

---

## Summary / Objective
Recover the three secret ingredients required to finish Rick’s pickle-reverse potion. This room hides clues client-side (HTML comments & `assets/` files) and requires basic web enumeration + static analysis.

**Answers (paste in exact format required by TryHackMe):**
1. First ingredient: **. ******* ****  
2. Second ingredient: * ***** ****  
3. Last ingredient: ***** *****

> Replace the placeholder lines above with the exact answers when submitting.

---

## Environment
- Host OS: macOS (browser + file transfer)
- Lab host / attack VM: Kali Linux VM (VMware)  
  - Kali IP: `192.168.99.128`
- VPN: TryHackMe OpenVPN config used (saved to `~/lab/tryhackme/tryhackme.ovpn`)
- Lab folder: `~/lab/tryhackme`
- Tools used: `curl`, `nmap`, `gobuster`, `wget`, `grep`, `strings`, `exiftool` (optional), text editor, browser DevTools, Burp Suite (optional)

---

## What I found (high level)
- HTML comment in `index.html` contained `Username: R1ckRul3s`.
- Additional clues were in `/assets` (JS / text files). The three secret ingredients were hidden client-side and discovered by enumerating assets and inspecting files.
- All testing performed against TryHackMe lab target only.

---

## Step-by-step commands (what I ran)
> Run these from `~/lab/tryhackme` — adjust `$TARGET` to the room IP if needed.

```bash
# set target (example)
TARGET=10.201.112.167
ART=~/lab/tryhackme/artifacts/$TARGET
mkdir -p "$ART"

# 1) Confirm connectivity
ping -c 3 $TARGET | tee "$ART/ping.txt"

# 2) Quick port/service discovery
nmap -Pn -sS -sV -T4 -oN "$ART/nmap_quick.txt" $TARGET

# 3) Mirror site for offline analysis
mkdir -p "$ART/web/wget_mirror"
wget --mirror --convert-links --adjust-extension --page-requisites --no-parent "http://$TARGET/" -P "$ART/web/wget_mirror"

# 4) Search static mirror for comments and clues
grep -RIn --line-number -E 'Username|remember|note|ingredient|secret|pickle|potion' "$ART/web/wget_mirror" | tee "$ART/web/grep_clues.txt"

# 5) Inspect main page (example)
sed -n '1,240p' "$ART/web/wget_mirror/$TARGET/index.html" > "$ART/web/index_preview.txt"

# 6) List assets and search them
find "$ART/web/wget_mirror/$TARGET/assets" -type f -maxdepth 2 -print > "$ART/web/assets_list.txt"
grep -RIn --line-number -E 'ingredient|secret|pickle|potion|R1ckRul3s|username|remember|note|flag' "$ART/web/wget_mirror/$TARGET/assets" | tee "$ART/web/assets_grep.txt"

# 7) If you find base64/hex strings, decode them (examples)
# base64: echo '...' | base64 -d
# hex: echo '68656c6c6f' | xxd -r -p

# 8) Brute-check a few likely paths (safe small list)
gobuster dir -u "http://$TARGET/" -w /tmp/tryhackme_small_paths.txt -o "$ART/web/gobuster_custom.txt" || true
