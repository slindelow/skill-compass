---
name: compass-audit
description: Audit installed agent capabilities for the current harness, then generate or refresh the skill-compass routing table. Use when the user installs or removes plugins, says "audit my skills", "what do I have installed", "update my routing table", or when skill-compass routes to something unavailable.
---

# Compass Audit

You are auditing this machine's actual installed capability surface and producing a personalized routing table. Do not copy a generic table. The value is that the output reflects what this user really has in this harness.

## Step 1 - Identify The Harness

Detect the active harness from the environment and repo files:

- **Claude Code:** `.claude-plugin/`, `~/.claude/`, Claude skills, Claude hooks, Claude built-ins.
- **Codex:** `.codex-plugin/`, Codex skills/plugins/apps/connectors, developer tools, built-in tools exposed in the current session.
- **Gemini CLI:** `gemini-extension.json`, `~/.gemini/`, `.gemini/`, Gemini extensions, commands, hooks, MCP servers, context files, agent skills.
- **Other harness:** inventory what is discoverable locally and record unknowns instead of guessing.

If multiple harnesses are present, audit the active one first, then mention the others as secondary adapters.

## Step 2 - Inventory Mechanically

Collect only metadata needed for routing:

1. Installed extensions/plugins and whether each is enabled.
2. Skills or prompt modules: read frontmatter/name/description only unless deeper inspection is needed.
3. Built-in slash commands, tools, apps/connectors, MCP servers, hooks, agents/subagents, and always-loaded context files.
4. Scope: global, project, plugin/extension, current session, or harness built-in.
5. Health signals: missing files, invalid layouts, stale/deprecated aliases, disabled entries, duplicate names, and version/source information when available.

Harness-specific starting points:

- Claude: `~/.claude/plugins/installed_plugins.json`, `~/.claude/settings.json`, `~/.claude/plugins/known_marketplaces.json`, `~/.claude/skills/`, project `.claude/skills/`, and session-provided skills.
- Codex: `.codex-plugin/plugin.json`, installed Codex plugin metadata exposed in the current session, `~/.codex/skills`, `~/.agents/skills`, plugin cache skills, apps/connectors, and active tool metadata.
- Gemini: `~/.gemini/settings.json`, `~/.gemini/extensions/`, project `.gemini/settings.json`, `GEMINI.md`, extension `skills/`, `commands/`, `hooks/`, `agents/`, `policies/`, and MCP declarations.

## Step 3 - Resolve Overlaps

Group capabilities by job, not by source. For every job with two or more contenders, choose a winner and record why. Apply these tie-breakers in order:

1. **User instruction beats everything.**
2. **Harness-native beats plugin** when the native capability has privileged workflow access.
3. **Always-loaded or hook-enforced beats advisory** in the exact domain it enforces.
4. **Specific beats general.**
5. **Maintained beats stale.**
6. **Consistent beats clever.** When two options are equivalent, pick one primary route and list the other as fallback.

Also produce a cleanup list with recommendations only. Do not delete or disable anything unless the user explicitly asks.

## Step 4 - Write Outputs

1. `AUDIT-<date>.md` - inventory, overlap map, cleanup list, and verification notes.
2. `skills/skill-compass/SKILL.md` - generated routing table grouped by workflow stage. Keep it under about 150 lines so it stays cheap to load.
3. `routing/COMPACT.md` - 10-20 lines of priority rules only.
4. If supported, stamp the harness fingerprint after the user accepts the generated table:
   - Claude: `bin/fingerprint.sh --harness claude --write`
   - Codex: `bin/fingerprint.sh --harness codex --write`
   - Gemini: `bin/fingerprint.sh --harness gemini --write`

## Step 5 - Verify

Dry-run five plausible recent or representative tasks against the new table. Each task should route to exactly one primary capability. If any task routes to zero or multiple primaries, fix the table before finishing.
