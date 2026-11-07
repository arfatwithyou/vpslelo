#!/bin/bash
set -e

echo ""
echo "╔══════════════════════════════════════╗"
echo "║   Railway VPS — Starting up...       ║"
echo "╚══════════════════════════════════════╝"
echo ""

# ── Password set karo ──────────────────────────────────────────────────────
# ROOT_PASSWORD env variable se aata hai (Railway Dashboard → Variables)
# Default password agar variable set nahi: Kittu@1234

PASS="${ROOT_PASSWORD:-Kittu@1234}"

echo "[*] Setting passwords..."
echo "root:${PASS}"   | chpasswd
echo "kittu:${PASS}"  | chpasswd

echo "[✓] root   password set"
echo "[✓] kittu  password set"
echo ""

# ── SSH daemon start karo ──────────────────────────────────────────────────
echo "[*] Starting SSH server on port 22..."
service ssh start || /usr/sbin/sshd

echo "[✓] SSH is running"
echo ""

# ── Railway public IP / hostname dikhao ───────────────────────────────────
echo "════════════════════════════════════"
echo "  SSH Connection Details"
echo "════════════════════════════════════"
echo "  Username : root   OR   kittu"
echo "  Password : ${PASS}"
echo ""
echo "  Railway hostname milega:"
echo "  Dashboard → Settings → Networking"
echo "  Wahan PORT note karo"
echo ""
echo "  Connect karo:"
echo "  ssh root@YOUR_RAILWAY_HOST -p PORT"
echo "════════════════════════════════════"
echo ""

# ── Container alive rakhne ke liye — infinite loop ────────────────────────
echo "[✓] VPS ready! Waiting..."
tail -f /dev/null
