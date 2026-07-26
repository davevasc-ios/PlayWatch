#!/bin/bash
# Configures everything the uploading workflows need on GitHub:
#
#   1. an SSH deploy key so the runner can clone the private certificates repo
#   2. the nine values from fastlane/.env, as secrets
#
# Values are piped straight from the local file into `gh`; none of them are
# printed, so nothing lands in the terminal scrollback or shell history.
#
# Safe to re-run: secrets are overwritten, and an existing deploy key with the
# same title is replaced.
#
# Usage:  ./.github/setup-secrets.sh

set -euo pipefail

REPO="davevasc-ios/PlayWatch"
CERTS_REPO="davevasc-ios/ios-certificates"
ENVIRONMENT="production"
KEY_TITLE="PlayWatch CI (fastlane match)"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$ROOT/fastlane/.env"
KEY_PATH="$HOME/.ssh/playwatch_match_deploy"

command -v gh >/dev/null || { echo "gh is not installed"; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "run 'gh auth login' first"; exit 1; }
[ -f "$ENV_FILE" ] || { echo "missing $ENV_FILE — run ./fastlane/setup-env.sh"; exit 1; }

# ── 1. Deploy key ────────────────────────────────────────────────────────
# A deploy key rather than a personal access token: it never expires and is
# scoped to this one repository, so it cannot touch anything else.
if [ ! -f "$KEY_PATH" ]; then
  echo "Generating a deploy key…"
  ssh-keygen -t ed25519 -N "" -C "playwatch-ci-match" -f "$KEY_PATH" >/dev/null
  echo "  ✓ $KEY_PATH"
else
  echo "  · reusing $KEY_PATH"
fi

existing="$(gh api "repos/$CERTS_REPO/keys" --jq ".[] | select(.title == \"$KEY_TITLE\") | .id" 2>/dev/null || true)"
if [ -n "$existing" ]; then
  echo "  · replacing the existing deploy key"
  echo "$existing" | while read -r id; do gh api -X DELETE "repos/$CERTS_REPO/keys/$id" >/dev/null; done
fi

gh api -X POST "repos/$CERTS_REPO/keys" \
  -f "title=$KEY_TITLE" \
  -f "key=$(cat "$KEY_PATH.pub")" \
  -F read_only=true >/dev/null
echo "  ✓ deploy key installed on $CERTS_REPO (read-only)"

# ── 2. Environment ───────────────────────────────────────────────────────
# Secrets live in an environment rather than at repository level so that
# ci.yml, which does not declare one, has no way to reach them even if a
# workflow is later edited by mistake.
scope=(--env "$ENVIRONMENT")
if gh api -X PUT "repos/$REPO/environments/$ENVIRONMENT" >/dev/null 2>&1; then
  echo "  ✓ environment '$ENVIRONMENT' ready"
else
  echo "  ! could not create the '$ENVIRONMENT' environment (needs a public repo"
  echo "    or GitHub Pro). Falling back to repository-level secrets."
  echo "    Re-run this script after making the repository public."
  scope=()
fi

# ── 3. Secrets ───────────────────────────────────────────────────────────
set_secret() {   # set_secret NAME VALUE
  printf '%s' "$2" | gh secret set "$1" --repo "$REPO" "${scope[@]}" >/dev/null
  echo "  ✓ $1"
}

echo "Uploading secrets…"
count=0
while IFS= read -r line; do
  case "$line" in
    \#*|"") continue ;;
    *=*)
      name="${line%%=*}"
      value="${line#*=}"
      [ -z "$value" ] && { echo "  ! $name is empty in .env — skipped"; continue; }
      set_secret "$name" "$value"
      count=$((count + 1))
      ;;
  esac
done < "$ENV_FILE"

set_secret MATCH_DEPLOY_KEY "$(cat "$KEY_PATH")"
count=$((count + 1))

echo
echo "$count secrets configured on $REPO${scope:+ (environment: $ENVIRONMENT)}"
echo
echo "Verify with:  gh secret list --repo $REPO ${scope[*]}"
