#!/usr/bin/env bash
# Creates a GitHub Release with attached assets, using the caller's own gh CLI login.
set -euo pipefail

if [ "$#" -lt 3 ]; then
    echo "Usage: push_release.sh <tag> <title> <notes_file> [asset_path ...]" >&2
    exit 1
fi

TAG="$1"
TITLE="$2"
NOTES_FILE="$3"
shift 3
ASSETS=("$@")

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_DIR"

if ! command -v gh >/dev/null 2>&1; then
    echo "ERROR: GitHub CLI 'gh' not found on PATH. Install it from https://cli.github.com and run 'gh auth login' once." >&2
    exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
    echo "ERROR: 'gh' is not logged in. Run 'gh auth login' once (it stores its own credentials), then re-run the release." >&2
    exit 1
fi

echo "Creating release $TAG in $REPO_DIR ..."
gh release create "$TAG" "${ASSETS[@]}" --title "$TITLE" --notes-file "$NOTES_FILE" --target main

echo "Release $TAG created."
