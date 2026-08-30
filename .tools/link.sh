#!/bin/bash
# ./link.sh <part-of-filename>   ->  prints + copies the public URL
set -euo pipefail
cd "$(dirname "$0")/.."
source .tools/config.sh
Q=${1:-}
if [ -z "$Q" ]; then echo "Usage: ./link <part of the file name>"; exit 1; fi
MATCHES=$(git ls-files | grep -Ei "\.($IMG_EXT)$" | grep -i -- "$Q" || true)
if [ -z "$MATCHES" ]; then echo "No image matching \"$Q\". Run Sync.command if you just added it."; exit 1; fi
URLS=""
while IFS= read -r f; do u="$BASE_URL/$f"; echo "$u"; URLS="${URLS}${u}\n"; done <<< "$MATCHES"
printf '%b' "$URLS" | pbcopy
echo "📋 Copied."
