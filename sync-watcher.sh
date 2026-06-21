#!/data/data/com.termux/files/usr/bin/bash
# Background watcher daemon for AI-Knowledge-Base → shared/AI-KB
# Watches for file changes and syncs automatically
# Requires: inotify-tools (pkg install inotify-tools)

SRC="$HOME/AI-Knowledge-Base"
DST="$HOME/storage/shared/AI-KB"
LOG="$HOME/.termux/ai-kb-sync.log"
PIDFILE="$HOME/.termux/ai-kb-sync.pid"

case "$1" in
  start)
    if [ -f "$PIDFILE" ] && kill -0 $(cat "$PIDFILE") 2>/dev/null; then
      echo "Watcher already running (PID $(cat $PIDFILE))"
      exit 1
    fi
    echo "Starting AI-KB sync watcher..."
    nohup bash "$0" watch > "$LOG" 2>&1 &
    echo $! > "$PIDFILE"
    echo "Started (PID $(cat $PIDFILE))"
    ;;
  stop)
    if [ -f "$PIDFILE" ] && kill -0 $(cat "$PIDFILE") 2>/dev/null; then
      kill $(cat "$PIDFILE")
      rm -f "$PIDFILE"
      echo "Stopped"
    else
      echo "Not running"
    fi
    ;;
  watch)
    # Initial sync
    cp -rf "$SRC/." "$DST/"
    # Watch for changes (every 2s debounce)
    while true; do
      inotifywait -r -e modify,create,delete,move "$SRC" 2>/dev/null
      sleep 2
      cp -rf "$SRC/." "$DST/"
    done
    ;;
  status)
    if [ -f "$PIDFILE" ] && kill -0 $(cat "$PIDFILE") 2>/dev/null; then
      echo "Running (PID $(cat $PIDFILE))"
    else
      echo "Stopped"
    fi
    ;;
  *)
    echo "Usage: bash $0 {start|stop|status}"
    ;;
esac
