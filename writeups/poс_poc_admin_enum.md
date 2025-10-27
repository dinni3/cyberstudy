# PoC: Juice Shop — Admin accounts & Stored XSS (lab)
**Target:** http://192.168.99.128:3000  
**Date:** 2025-10-24  
**Author:** dinnie

## Executive summary
During a local lab assessment of OWASP Juice Shop, I recovered the application SQLite database, enumerated user accounts, and confirmed several admin accounts exist. I also validated a stored-XSS PoC on Product 1. All testing was performed in a lab environment.

## Key findings
1. **Database accessible (lab-only)** — local copy of `juiceshop.sqlite` extracted from the running container.  
   - Path (local copy): `~/lab/juice-shop/container_dump/juice-shop/data/juiceshop.sqlite`  
   - Redacted artifact: `~/lab/juice-shop/artifacts/idor/admin_users_redacted.csv`

2. **Admin accounts discovered (read-only)**  
   - Admin user IDs: `1, 4, 6, 9, 10, 12, 22`  
   - Redacted admin CSV: `~/lab/juice-shop/artifacts/idor/admin_users_redacted.csv`

3. **Stored XSS (Product 1)** — successful PoC injected and stored in product reviews (lab).  
   - Target product: `/#/product/1`  
   - Payload used: `<p>poc-xss-01</p><svg/onload=console.log("poc-xss-01")>`  
   - Artifacts: `~/lab/juice-shop/artifacts/xss_payload.json` (redact token before sharing)

## Evidence & artifacts (redacted)
- `~/lab/juice-shop/artifacts/idor/admin_users_redacted.csv` — CSV of admin user rows (no passwords).  
- `~/lab/juice-shop/artifacts/idor/whoami_db_admin.txt` — DB-derived admin summary.  
- `~/lab/juice-shop/artifacts/idor/enum_*` — saved headers & responses from automated enumeration (contains raw data; may contain tokens — they were redacted if found).  
- Stored XSS artifacts: `~/lab/juice-shop/artifacts/requests/xss_payload.json`, `~/lab/juice-shop/artifacts/responses/xss_response_redacted.txt`, `~/lab/juice-shop/artifacts/responses/product_1.html`.

## Impact
- In a real production environment, exposing a site DB or admin accounts would be **high impact** (unauthorized access, data exfiltration, privilege escalation). In this lab, the artifacts are for demonstration / learning only.

## Recommendations
- Deny public access to `.git`, `.env`, and any internal data files.  
- Do not expose or distribute application DBs in production; use secure configuration and volumes.  
- Ensure proper API routing so that frontend fallback does not inadvertently obfuscate backend behavior.  
- Implement proper output encoding and input validation to prevent stored XSS.

## Next steps (suggested)
- Continue web app auth testing (IDOR, session fixation, JWT validation).  
- Practice Burp Repeater flows to validate admin-only endpoints using browser-captured tokens.  
- Prepare a short technical report including sanitized request/response PoCs and remediation steps.

