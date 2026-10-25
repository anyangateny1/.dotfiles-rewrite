#!/usr/bin/env python3
"""
Sync LeetCode session cookies from Firefox (or Chrome fallback) directly to leetcode.nvim cache.
"""

import sys
import os
import glob
import shutil
import tempfile
import sqlite3
import hashlib
import subprocess

def extract_firefox_cookies():
    profiles_dir = os.path.expanduser("~/Library/Application Support/Firefox/Profiles")
    if not os.path.isdir(profiles_dir):
        return None

    profiles = glob.glob(os.path.join(profiles_dir, "*"))
    valid_profiles = [p for p in profiles if os.path.exists(os.path.join(p, "cookies.sqlite"))]
    if not valid_profiles:
        return None

    # Pick the most recently modified profile
    valid_profiles.sort(key=lambda p: os.path.getmtime(os.path.join(p, "cookies.sqlite")), reverse=True)
    profile = valid_profiles[0]
    src = os.path.join(profile, "cookies.sqlite")

    tmp_db = tempfile.mktemp(suffix=".sqlite")
    try:
        shutil.copy2(src, tmp_db)
        conn = sqlite3.connect(tmp_db)
        rows = conn.execute(
            "SELECT name, value FROM moz_cookies "
            "WHERE host LIKE '%leetcode.com' AND name IN ('csrftoken', 'LEETCODE_SESSION') "
            "ORDER BY creationTime DESC"
        ).fetchall()
        conn.close()
    except Exception:
        return None
    finally:
        if os.path.exists(tmp_db):
            os.unlink(tmp_db)

    cookies = {}
    for name, val in rows:
        if name not in cookies and val:
            cookies[name] = val

    if "csrftoken" in cookies and "LEETCODE_SESSION" in cookies:
        return cookies, f"Firefox ({os.path.basename(profile)})"
    return None

def get_chrome_key():
    try:
        chrome_pass = subprocess.check_output(
            ["security", "find-generic-password", "-w", "-s", "Chrome Safe Storage", "-a", "Chrome"],
            stderr=subprocess.DEVNULL
        ).strip()
    except subprocess.CalledProcessError:
        return None
    return hashlib.pbkdf2_hmac("sha1", chrome_pass, b"saltysalt", 1003, dklen=16)

def decrypt_chrome_v10(enc_bytes, key_hex):
    if not enc_bytes.startswith(b"v10"):
        return None
    ciphertext = enc_bytes[3:]
    iv_hex = "20" * 16
    proc = subprocess.run(
        ["openssl", "enc", "-aes-128-cbc", "-d", "-K", key_hex, "-iv", iv_hex],
        input=ciphertext,
        capture_output=True
    )
    if proc.returncode == 0 and len(proc.stdout) > 32:
        return proc.stdout[32:].decode("utf-8", errors="replace").strip()
    return None

def extract_chrome_cookies():
    cookie_db = os.path.expanduser("~/Library/Application Support/Google/Chrome/Default/Cookies")
    if not os.path.exists(cookie_db):
        return None

    key = get_chrome_key()
    if not key:
        return None
    key_hex = key.hex()

    tmp_db = tempfile.mktemp(suffix=".sqlite")
    try:
        shutil.copy2(cookie_db, tmp_db)
        conn = sqlite3.connect(tmp_db)
        rows = conn.execute(
            "SELECT name, host_key, encrypted_value FROM cookies "
            "WHERE host_key LIKE '%leetcode.com' AND name IN ('csrftoken', 'LEETCODE_SESSION') "
            "ORDER BY creation_utc DESC"
        ).fetchall()
        conn.close()
    except Exception:
        return None
    finally:
        if os.path.exists(tmp_db):
            os.unlink(tmp_db)

    cookies = {}
    for name, host, enc in rows:
        if name in cookies:
            continue
        val = decrypt_chrome_v10(enc, key_hex)
        if val:
            cookies[name] = val

    if "csrftoken" in cookies and "LEETCODE_SESSION" in cookies:
        return cookies, "Google Chrome"
    return None

def main():
    # Try Firefox first (user preference), then Chrome
    result = extract_firefox_cookies()
    if not result:
        result = extract_chrome_cookies()

    if not result:
        print("[!] No active LeetCode session found in Firefox (or Chrome).", file=sys.stderr)
        print("[*] Please log into https://leetcode.com in Firefox first, then rerun.", file=sys.stderr)
        sys.exit(1)

    cookies, source = result
    dest_dir = os.path.expanduser("~/.cache/nvim/leetcode")
    os.makedirs(dest_dir, exist_ok=True)
    dest_file = os.path.join(dest_dir, "cookie")

    cookie_str = f"csrftoken={cookies['csrftoken']}; LEETCODE_SESSION={cookies['LEETCODE_SESSION']}"
    with open(dest_file, "w") as f:
        f.write(cookie_str)

    print(f"[+] Successfully synced LeetCode session from {source} to {dest_file}")

if __name__ == "__main__":
    main()
