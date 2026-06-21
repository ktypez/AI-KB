#!/data/data/com.termux/files/usr/bin/bash
# Sync AI-Knowledge-Base to ~/storage/shared/AI-KB
# Run manually: bash AI-Knowledge-Base/sync-to-shared.sh

SRC="$HOME/AI-Knowledge-Base"
DST="$HOME/storage/shared/AI-KB"

echo "Syncing $SRC → $DST ..."
cp -rf "$SRC" "$DST"
echo "Done: $(date)"
