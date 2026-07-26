#!/bin/bash
# Populates fastlane/.env from credentials already on this machine.
#
# Values are read straight from disk and written straight to the file: they are
# never printed, so nothing ends up in your terminal scrollback.
#
# Two values cannot be derived and are left for you to fill in:
#   ASC_ISSUER_ID   — App Store Connect → Users and Access → Integrations
#   MATCH_PASSWORD  — a passphrase you choose on the first `fastlane certificates`
#
# Usage:  ./fastlane/setup-env.sh /path/to/AuthKey_XXXXXXXX.p8

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$ROOT/fastlane/.env"
TEMPLATE="$ROOT/fastlane/.env.template"
PLIST="$ROOT/PlayWatch/Network/Configuration/APIKey-Info.plist"
P8="${1:-}"

[ -n "$P8" ] || { echo "usage: $0 /path/to/AuthKey_XXXXXXXX.p8"; exit 1; }
[ -f "$P8" ] || { echo "not found: $P8"; exit 1; }

if [ -f "$ENV_FILE" ]; then
  read -rp "fastlane/.env already exists. Overwrite? [y/N] " reply
  [[ "$reply" =~ ^[Yy]$ ]] || { echo "aborted"; exit 0; }
fi

cp "$TEMPLATE" "$ENV_FILE"
chmod 600 "$ENV_FILE"

set_value() {   # set_value KEY VALUE
  python3 - "$ENV_FILE" "$1" "$2" <<'PY'
import sys
path, key, value = sys.argv[1], sys.argv[2], sys.argv[3]
lines = open(path).read().split("\n")
for i, line in enumerate(lines):
    if line.startswith(f"{key}="):
        lines[i] = f"{key}={value}"
        break
else:
    lines.append(f"{key}={value}")
open(path, "w").write("\n".join(lines))
PY
}

# Key ID is encoded in Apple's filename: AuthKey_2HCHJJV4Q7.p8
KEY_ID="$(basename "$P8" .p8 | sed 's/^AuthKey_//')"
set_value ASC_KEY_ID "$KEY_ID"

# Single-line base64. The raw PEM's newlines are the usual cause of
# "Authentication credentials are missing or invalid" mid-pipeline.
set_value ASC_KEY_P8_BASE64 "$(base64 -i "$P8" | tr -d '\n')"

# The four app keys already live in the gitignored plist.
if [ -f "$PLIST" ]; then
  copied=0
  for key in MOVIEDB_API_KEY OPENAI_API_KEY GEMINI_API_KEY DEEP_SEEK_API_KEY; do
    value="$(/usr/libexec/PlistBuddy -c "Print :$key" "$PLIST" 2>/dev/null || true)"
    # Refuse placeholders. The plist is rendered from the template during CI
    # runs, so a local copy can end up holding YOUR_..._HERE values; copying
    # those into .env would produce a build that authenticates against nothing.
    if [[ "$value" == YOUR_*_HERE ]]; then
      echo "! $key still holds the template placeholder — not copied"
      continue
    fi
    if [ -n "$value" ]; then set_value "$key" "$value"; copied=$((copied + 1)); fi
  done
  echo "✓ $copied app API keys copied from APIKey-Info.plist"
else
  echo "! APIKey-Info.plist not found; fill the four app keys by hand"
fi

echo "✓ ASC_KEY_ID set to $KEY_ID"
echo "✓ App Store Connect key encoded"
echo
echo "Still to fill in by hand:"
missing=0
while IFS= read -r line; do
  case "$line" in
    \#*|"") continue ;;
    *=*)
      k="${line%%=*}"; v="${line#*=}"
      if [ -z "$v" ]; then echo "   $k"; missing=$((missing + 1)); fi ;;
  esac
done < "$ENV_FILE"
[ "$missing" -eq 0 ] && echo "   (nothing — .env is complete)"
echo
echo "Open it with:  open -e fastlane/.env"
