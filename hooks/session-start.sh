#!/usr/bin/env bash
# skill-compass SessionStart hook.
#  1. Injects the compact routing rules into every session.
#  2. Detects whether the installed plugin/skill surface changed since the last
#     audit and, if so, tells the assistant to auto-run compass-audit.
# There is no "plugin installed" event in Claude Code, so this next-session-start
# check is the automatic-refresh mechanism.
set -euo pipefail
ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
STATE="$HOME/.claude/.skill-compass-fingerprint"

# 1. Always inject the routing rules.
cat "$ROOT/routing/COMPACT.md" 2>/dev/null || true

# 2. Drift check (never fail the session on error).
current="$("$ROOT/bin/fingerprint.sh" --harness claude 2>/dev/null || echo err)"
[ "$current" = "err" ] && exit 0
stored="$(cat "$STATE" 2>/dev/null || echo none)"

if [ "$current" != "$stored" ]; then
  if [ "$stored" = "none" ]; then
    echo "<skill-compass-audit>No skill-compass baseline exists yet. Invoke the compass-audit skill to generate the routing table, then stamp the baseline with bin/fingerprint.sh --harness claude --write.</skill-compass-audit>"
  else
    echo "<skill-compass-audit>Installed Claude plugins/skills changed since the last audit, so the skill-compass routing table may be stale. Invoke compass-audit before relying on old routing. If the user's first request is urgent, tell them the table is stale and offer to refresh after.</skill-compass-audit>"
  fi
fi
