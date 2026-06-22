#!/data/data/com.termux/files/usr/bin/bash
# Sync AI-KB to ~/storage/shared/AI-KB
# Run manually: bash ~/AI-KB/sync-to-shared.sh

SRC="$HOME/AI-KB"
DST="$HOME/storage/shared/AI-KB"

echo "Syncing $SRC → $DST ..."
cp -rf "$SRC/." "$DST/"
echo "Done: $(date)"
