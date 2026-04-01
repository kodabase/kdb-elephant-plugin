#!/bin/bash
# Elephant worker ensure-running hook script
# Called by Claude Code SessionStart hook
# Outputs JSON to stdout for Claude Code to display as context

ELEPHANT_BIN="${CLAUDE_PLUGIN_ROOT}/bin/elephant"
ELEPHANT_DATA="${ELEPHANT_DATA_DIR:-$HOME/.claude-elephant}"

# Ensure data directory exists
mkdir -p "$ELEPHANT_DATA" "$ELEPHANT_DATA/projects" 2>/dev/null || true

# Check if worker is already running
if curl -s -o /dev/null -w '' --connect-timeout 1 "http://127.0.0.1:37888/api/health" 2>/dev/null; then
    # Count standards and rules
    STATS=$(curl -s --connect-timeout 2 "http://127.0.0.1:37888/api/dashboard/summary" 2>/dev/null)
    STDS=$(echo "$STATS" | python3 -c "import sys,json; print(json.load(sys.stdin).get('standards_count',0))" 2>/dev/null || echo "?")
    RULES=$(echo "$STATS" | python3 -c "import sys,json; print(json.load(sys.stdin).get('rules_count',0))" 2>/dev/null || echo "?")
    echo "Elephant ready | ${STDS} standards, ${RULES} rules loaded" >&2
    exit 0
fi

# Start worker in background
if [ -x "$ELEPHANT_BIN" ]; then
    echo "Starting Elephant worker..." >&2
    nohup "$ELEPHANT_BIN" worker start --foreground > "$ELEPHANT_DATA/elephant.log" 2>&1 &

    # Wait up to 5s for health check
    for i in $(seq 1 10); do
        sleep 0.5
        if curl -s -o /dev/null --connect-timeout 1 "http://127.0.0.1:37888/api/health" 2>/dev/null; then
            STATS=$(curl -s --connect-timeout 2 "http://127.0.0.1:37888/api/dashboard/summary" 2>/dev/null)
            STDS=$(echo "$STATS" | python3 -c "import sys,json; print(json.load(sys.stdin).get('standards_count',0))" 2>/dev/null || echo "?")
            RULES=$(echo "$STATS" | python3 -c "import sys,json; print(json.load(sys.stdin).get('rules_count',0))" 2>/dev/null || echo "?")
            echo "Elephant started | ${STDS} standards, ${RULES} rules loaded" >&2
            exit 0
        fi
    done

    echo "Elephant worker starting (may take a moment)..." >&2
else
    echo "Elephant binary not found at ${ELEPHANT_BIN}" >&2
fi

# Always exit 0 — don't block session
exit 0
