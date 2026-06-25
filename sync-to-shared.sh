#!/data/data/com.termux/files/usr/bin/bash
# Sync AI-KB to ~/storage/shared/AI-KB — including deletes
# Run manually: bash ~/AI-KB/sync-to-shared.sh

SRC="$HOME/AI-KB"
DST="$HOME/storage/shared/AI-KB"

echo "Syncing $SRC → $DST ..."

# Copy new/updated files
cp -rf "$SRC/." "$DST/"

# Remove files in DST that no longer exist in SRC
while IFS= read -r -d '' f; do
  rel="${f#$DST/}"
  if [ ! -e "$SRC/$rel" ]; then
    rm -f "$f"
  fi
done < <(find "$DST" -type f -print0)

# Remove empty dirs in DST
find "$DST" -type d -empty -delete 2>/dev/null

echo "Done: $(date)"
