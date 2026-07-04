#!/usr/bin/env bash
# Prints a fingerprint of the installed capability surface for one harness.
# Deliberately ignores volatile fields like model/theme, but includes names,
# enablement, and skill frontmatter/content hashes that affect routing.
#
#   fingerprint.sh --harness claude
#   fingerprint.sh --harness codex --write
#   fingerprint.sh --harness gemini
set -euo pipefail

harness="claude"
write="false"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --harness)
      harness="${2:-}"
      shift 2
      ;;
    --write)
      write="true"
      shift
      ;;
    *)
      echo "usage: $0 [--harness claude|codex|gemini] [--write]" >&2
      exit 2
      ;;
  esac
done

case "$harness" in
  claude|codex|gemini) ;;
  *)
    echo "unsupported harness: $harness" >&2
    exit 2
    ;;
esac

STATE="$HOME/.skill-compass-${harness}-fingerprint"
[ "$harness" = "claude" ] && STATE="$HOME/.claude/.skill-compass-fingerprint"

current="$(HARNESS="$harness" python3 - <<'PY' 2>/dev/null | shasum -a 256 | cut -d' ' -f1
import hashlib
import json
import os
from pathlib import Path

home = Path.home()
harness = os.environ["HARNESS"]

def emit(value):
    print(value)

def load_json(path):
    try:
        return json.loads(Path(path).read_text())
    except Exception:
        return None

def hash_file(path):
    try:
        data = Path(path).read_bytes()
    except Exception:
        return "missing"
    return hashlib.sha256(data).hexdigest()[:16]

def skill_dirs(root):
    root = Path(root).expanduser()
    if not root.exists():
        return
    for child in sorted(root.iterdir()):
        skill = child / "SKILL.md"
        if child.is_dir() and skill.exists():
            emit(f"skill:{child.name}:{hash_file(skill)}")
        elif child.is_file() and child.name.endswith("_SKILL.md"):
            emit(f"broken-flat-skill:{child.name}:{hash_file(child)}")

if harness == "claude":
    base = home / ".claude"
    installed = load_json(base / "plugins" / "installed_plugins.json") or {}
    for name in sorted((installed.get("plugins") or {}).keys()):
        emit("plugin:" + name)
    settings = load_json(base / "settings.json") or {}
    enabled = settings.get("enabledPlugins") or {}
    if isinstance(enabled, dict):
        for name, value in sorted(enabled.items()):
            emit(f"enabled:{name}={value}")
    skill_dirs(base / "skills")

elif harness == "codex":
    for root in [
        home / ".codex" / "skills",
        home / ".agents" / "skills",
        home / ".codex" / "plugins" / "cache",
    ]:
        skill_dirs(root)
    for manifest in sorted((home / ".codex" / "plugins" / "cache").glob("**/.codex-plugin/plugin.json")):
        data = load_json(manifest) or {}
        emit(f"plugin:{data.get('name', manifest.parent.parent.name)}:{data.get('version', 'unknown')}")

elif harness == "gemini":
    base = home / ".gemini"
    for manifest in sorted((base / "extensions").glob("*/gemini-extension.json")):
        data = load_json(manifest) or {}
        emit(f"extension:{data.get('name', manifest.parent.name)}:{data.get('version', 'unknown')}")
        skill_dirs(manifest.parent / "skills")
        for rel in ["GEMINI.md", "hooks/hooks.json"]:
            path = manifest.parent / rel
            if path.exists():
                emit(f"{rel}:{manifest.parent.name}:{hash_file(path)}")
    settings = load_json(base / "settings.json") or {}
    for key in ["contextFileName", "mcpServers", "allowMCPServers", "excludeMCPServers"]:
        if key in settings:
            emit(f"setting:{key}:{hashlib.sha256(json.dumps(settings[key], sort_keys=True).encode()).hexdigest()[:16]}")
PY
)"

if [ "$write" = "true" ]; then
  mkdir -p "$(dirname "$STATE")"
  echo "$current" > "$STATE"
  echo "skill-compass $harness baseline stamped: $current"
else
  echo "$current"
fi
