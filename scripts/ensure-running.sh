#!/bin/bash
# Elephant worker ensure-running hook script
# Called by Claude Code SessionStart hook
# Must exit 0 to not block the session

set -e

ELEPHANT_BIN="${CLAUDE_PLUGIN_ROOT}/bin/elephant"
ELEPHANT_DATA="${ELEPHANT_DATA_DIR:-$HOME/.claude-elephant}"

# Ensure data directory exists
mkdir -p "$ELEPHANT_DATA" "$ELEPHANT_DATA/projects" 2>/dev/null || true

# Check if worker is already running
if curl -s -o /dev/null -w '' --connect-timeout 1 "http://127.0.0.1:37888/api/health" 2>/dev/null; then
    exit 0
fi

# Start worker in background
if [ -x "$ELEPHANT_BIN" ]; then
    nohup "$ELEPHANT_BIN" worker start --foreground > "$ELEPHANT_DATA/elephant.log" 2>&1 &

    # Wait up to 5s for health check
    for i in $(seq 1 10); do
        sleep 0.5
        if curl -s -o /dev/null --connect-timeout 1 "http://127.0.0.1:37888/api/health" 2>/dev/null; then
            exit 0
        fi
    done
fi

# Always exit 0 — don't block session if worker fails to start
exit 0
