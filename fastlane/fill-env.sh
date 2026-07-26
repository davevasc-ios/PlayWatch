#!/bin/bash
# Prompts for whatever fastlane/.env is still missing and writes it in place.
#
# Values with "PASSWORD" or "SECRET" in the name are read without echoing, so
# they never appear on screen or in shell history.
#
# Usage:  ./fastlane/fill-env.sh

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$ROOT/fastlane/.env"

[ -f "$ENV_FILE" ] || { echo "fastlane/.env not found — run ./fastlane/setup-env.sh first"; exit 1; }

# What each field is, so you are not guessing at the prompt.
describe() {
  case "$1" in
    ASC_ISSUER_ID)  echo "UUID from App Store Connect > Users and Access > Integrations (above the key table)" ;;
    MATCH_PASSWORD) echo "a passphrase you choose; it encrypts your certificates — save it in your password manager" ;;
    ASC_KEY_ID)     echo "the XXXXXXXX part of AuthKey_XXXXXXXX.p8" ;;
    *)              echo "" ;;
  esac
}

missing=()
while IFS= read -r line; do
  case "$line" in
    \#*|"") continue ;;
    *=*) key="${line%%=*}"; value="${line#*=}"
         [ -z "$value" ] && missing+=("$key") ;;
  esac
done < "$ENV_FILE"

if [ ${#missing[@]} -eq 0 ]; then
  echo "✓ fastlane/.env is already complete"
  exit 0
fi

echo "${#missing[@]} field(s) still empty."
echo

for key in "${missing[@]}"; do
  hint="$(describe "$key")"
  [ -n "$hint" ] && echo "  $key — $hint"

  if [[ "$key" == *PASSWORD* || "$key" == *SECRET* ]]; then
    read -rsp "  $key: " value; echo
  else
    read -rp "  $key: " value
  fi

  if [ -z "$value" ]; then
    echo "  (skipped)"; echo; continue
  fi

  python3 - "$ENV_FILE" "$key" "$value" <<'PY'
import sys
path, key, value = sys.argv[1], sys.argv[2], sys.argv[3]
lines = open(path).read().split("\n")
for i, line in enumerate(lines):
    if line.startswith(f"{key}="):
        lines[i] = f"{key}={value}"
        break
open(path, "w").write("\n".join(lines))
PY
  echo "  ✓ saved"
  echo
done

remaining=0
while IFS= read -r line; do
  case "$line" in
    \#*|"") continue ;;
    *=*) [ -z "${line#*=}" ] && remaining=$((remaining + 1)) ;;
  esac
done < "$ENV_FILE"

if [ "$remaining" -eq 0 ]; then
  echo "✓ fastlane/.env is complete"
else
  echo "! $remaining field(s) still empty — run this again when you have them"
fi
