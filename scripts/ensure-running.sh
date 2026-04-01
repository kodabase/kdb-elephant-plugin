#!/bin/bash
# Elephant worker ensure-running hook script
# Called by Claude Code SessionStart hook

ELEPHANT_BIN="${CLAUDE_PLUGIN_ROOT}/bin/elephant"
ELEPHANT_DATA="${ELEPHANT_DATA_DIR:-$HOME/.claude-elephant}"

# Ensure data directory exists
mkdir -p "$ELEPHANT_DATA" "$ELEPHANT_DATA/projects" 2>/dev/null || true

# Check if worker is already running
if curl -s -o /dev/null -w '' --connect-timeout 1 "http://127.0.0.1:37888/api/health" 2>/dev/null; then
    STATS=$(curl -s --connect-timeout 2 "http://127.0.0.1:37888/api/dashboard/summary" 2>/dev/null)
    STDS=$(echo "$STATS" | python3 -c "import sys,json; print(json.load(sys.stdin).get('standards_count',0))" 2>/dev/null || echo "0")
    RULES=$(echo "$STATS" | python3 -c "import sys,json; print(json.load(sys.stdin).get('rules_count',0))" 2>/dev/null || echo "0")
    # Output status message via JSON stdout
    cat <<EOJSON
{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"Elephant v1.0.0 ready | ${STDS} standards, ${RULES} rules loaded"}}
EOJSON
    exit 0
fi

# Start worker in background
if [ -x "$ELEPHANT_BIN" ]; then
    nohup "$ELEPHANT_BIN" worker start --foreground > "$ELEPHANT_DATA/elephant.log" 2>&1 &

    # Wait up to 5s for health check
    for i in $(seq 1 10); do
        sleep 0.5
        if curl -s -o /dev/null --connect-timeout 1 "http://127.0.0.1:37888/api/health" 2>/dev/null; then
            STATS=$(curl -s --connect-timeout 2 "http://127.0.0.1:37888/api/dashboard/summary" 2>/dev/null)
            STDS=$(echo "$STATS" | python3 -c "import sys,json; print(json.load(sys.stdin).get('standards_count',0))" 2>/dev/null || echo "0")
            RULES=$(echo "$STATS" | python3 -c "import sys,json; print(json.load(sys.stdin).get('rules_count',0))" 2>/dev/null || echo "0")
            cat <<EOJSON
{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"Elephant v1.0.0 started | ${STDS} standards, ${RULES} rules loaded"}}
EOJSON
            exit 0
        fi
    done
fi

# Always exit 0
exit 0
