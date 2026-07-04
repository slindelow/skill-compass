---
name: compass-audit
description: Audit every installed skill, plugin, agent, and built-in tool, then generate or refresh the user's skill-compass routing table. Use when the user installs or removes plugins, says "audit my skills", "what do I have installed", "update my routing table", or when skill-compass routes to something that no longer exists.
---

# Compass Audit — regenerate the routing table

You are auditing this machine's actual installed capability surface and producing a personalized routing table. Do not copy a generic table — the value is that it reflects what THIS user really has.

## Step 1 — Inventory (all mechanical, no judgment yet)

1. CLI-installed plugins: read `~/.claude/plugins/installed_plugins.json` and `~/.claude/settings.json` (`enabledPlugins`). Note versions and marketplace sources from `~/.claude/plugins/known_marketplaces.json`.
2. Per-plugin skills: for each install path, `ls <installPath>/skills/` and read each `SKILL.md` frontmatter (name + description only — do not read bodies).
3. User skills: `ls ~/.claude/skills/` — flag any flat `*_SKILL.md` files as broken (skills must be `<dir>/SKILL.md`).
4. Project skills: `ls .claude/skills/` in the current project and any sibling projects the user names.
5. Session-provided skills: whatever the current session's available-skills list shows that isn't covered above (desktop-app plugin bundles, built-ins like /code-review, /verify, /loop, /schedule, deep-research, claude-api).
6. Agents: note available agent types (subagent personas count as routable capabilities).

## Step 2 — Overlap analysis (the actual work)

Group everything by JOB, not by source. For each job with 2+ contenders, pick a winner and record why. Apply these tie-breakers in order:

1. **Hook-enforced beats advisory** (a plugin that injects itself at SessionStart, like superpowers, wins its domain).
2. **Built-in beats plugin** when the built-in is harness-wired (can apply fixes, post PR comments, schedule).
3. **Specific beats general** (a PR-review skill beats a generic review skill for PRs).
4. **Maintained beats stale** (check versions/last-updated).
5. When genuinely equivalent, pick one and commit — inconsistency costs more than the wrong choice.

Also produce: a dead-weight list (broken files, deprecated aliases, plugins with zero unique value) with removal recommendations. Recommend, don't delete.

## Step 3 — Write the outputs

1. `AUDIT-<date>.md` — inventory + overlap map + cleanup list (next to this skill's plugin root, or where the user keeps it).
2. Rewrite `skills/skill-compass/SKILL.md`'s routing table: route-by-intent tables grouped by workflow stage (starting / building / finishing / memory / research / data / documents / automation / user-specific), a short "priority rules" section at top (≤5 rules), and a "never use" list. Keep the whole skill under ~150 lines — it must stay cheap to load.
3. If the plugin's SessionStart hook is active, regenerate the compact injection file (`routing/COMPACT.md`) — the 20-line distillation of the priority rules only.

## Step 4 — Verify

Pick 5 random real tasks the user has done recently (ask, or check memory/git history) and dry-run them against the new table: does each route to exactly one primary skill? If any routes to zero or 2+, fix the table before finishing.
