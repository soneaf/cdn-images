#!/bin/bash
# Publish everything in this folder to GitHub and print the public image URLs.
set -euo pipefail
cd "$(dirname "$0")/.."
source .tools/config.sh

printf '\n\033[1m📤  Publishing images…\033[0m\n\n'

find . -name '.DS_Store' -delete 2>/dev/null || true
python3 .tools/sanitize.py
python3 .tools/gen_gallery.py "$BASE_URL" >/dev/null

git add -A
CHANGED=$(git diff --cached --name-only --diff-filter=ACMR | grep -Ei "\.($IMG_EXT)$" || true)

if git diff --cached --quiet; then
  printf '   Nothing new to publish — everything is already live.\n'
else
  git commit -qm "sync $(date '+%Y-%m-%d %H:%M')"
  git push -q origin main
  COUNT=$(printf '%s' "$CHANGED" | grep -c . || true)
  printf '   \033[32m✓\033[0m Pushed. %s image(s) added or updated.\n' "${COUNT:-0}"
fi

ALL=$(git ls-files | grep -Ei "\.($IMG_EXT)$" || true)
if [ -z "$ALL" ]; then
  printf '\n   No images in the folder yet. Drop some in and run this again.\n\n'
  exit 0
fi

if [ -n "${CHANGED:-}" ]; then
  LIST=$CHANGED
  HEADER="Links for what you just added:"
else
  LIST=$ALL
  HEADER="All image links:"
fi

printf '\n\033[1m%s\033[0m\n\n' "$HEADER"
URLS=""
while IFS= read -r f; do
  [ -z "$f" ] && continue
  u="$BASE_URL/${f#./}"
  printf '   %s\n' "$u"
  URLS="${URLS}${u}\n"
done <<< "$LIST"

printf '%b' "$URLS" | pbcopy
printf '\n   \033[32m📋 Copied to your clipboard.\033[0m\n'
printf '   Browse them all with pictures:  \033[4m%s/\033[0m\n\n' "$BASE_URL"
