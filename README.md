# skill-compass

A meta-aware skill/plugin/tool orchestrator for Claude Code. Most power users accumulate 100+ skills across plugins and forget what they have; Claude then routes inconsistently when several skills overlap. skill-compass fixes both with three parts:

- **`compass-audit` skill** — scans everything actually installed (CLI plugins, desktop-app bundles, user/project skills, built-ins, agents), maps overlaps, and generates a personalized routing table.
- **`skill-compass` skill** — the routing table itself. Auto-invoked when Claude is unsure which capability to use, or on demand ("what should I use for X?").
- **SessionStart hook** — injects a 12-line compact version of the priority rules into every session, so routing happens correctly *before* skill matching, with zero user effort. This is the genuinely autonomous part.

Design principle: routing is a context problem, not an intelligence problem. Descriptions already trigger skills; what's missing is a tie-breaker that's always in context. The hook provides it.

## Repo layout

```
skill-compass/
├── .claude-plugin/plugin.json     # plugin manifest
├── skills/
│   ├── skill-compass/SKILL.md     # the routing table (personalized — regenerate per user)
│   └── compass-audit/SKILL.md     # the generator/auditor
├── hooks/hooks.json               # SessionStart → inject routing/COMPACT.md
├── routing/COMPACT.md             # 12-line priority rules injected each session
├── AUDIT-2026-07-04.md            # Sofia's full audit (example output; delete for public release)
└── README.md
```

## Personal use (works today, no plugin machinery)

Copy the two skill folders into `~/.claude/skills/`. Done — every Claude Code session on this machine can now invoke them. The hook only activates via plugin install (below) or by manually adding it to `~/.claude/settings.json`.

## Turning this into a ready-for-public plugin — exact steps

1. **De-personalize.** The shipped `skills/skill-compass/SKILL.md` must be a *template* with a `<!-- GENERATED: run compass-audit -->` marker, not Sofia's table. Move the personal table + `AUDIT-2026-07-04.md` out (they stay local). The public value proposition: install → run `compass-audit` once → get YOUR table. Remove the Sofia-specific routing section from the template entirely.
2. **First-run experience.** Add a note in the plugin description and README: "After installing, say `audit my skills`." Optionally add a SessionStart hook line that detects a missing generated table and prompts the user to run the audit (check: does `routing/COMPACT.md` contain the GENERATED marker?).
3. **Validate the manifest.** `claude plugin validate .` from the repo root (checks plugin.json, hooks.json, skill frontmatter).
4. **Test locally before publishing.** `claude --plugin-dir /path/to/skill-compass` loads it as a dev plugin in a fresh session. Verify: (a) both skills appear, (b) the hook injects COMPACT.md at session start, (c) compass-audit produces a sane table on a machine that isn't yours — this is the real test; run it in a clean VM or a friend's setup if possible.
5. **Create the GitHub repo.** `gh repo create slindelow/skill-compass --public --source . --push`. MIT license, README with a 30-second demo GIF (asciinema or a short screen recording — installs, audit runs, table appears).
6. **Make it installable.** Two options:
   - Direct: users run `/plugin install` pointing at the GitHub repo (`claude plugin install slindelow/skill-compass` or add via `extraKnownMarketplaces`).
   - Marketplace: add a `.claude-plugin/marketplace.json` listing this plugin, so the repo doubles as a one-plugin marketplace (`/plugin marketplace add slindelow/skill-compass`). This is what superpowers and claude-mem do.
7. **Version + release.** Tag `v0.1.0`, create a GitHub release. Bump versions in `plugin.json` on every change — Claude Code caches by version.
8. **Announce.** This is a natural @slindelow build-in-public arc: the problem (130 skills, no recall), the insight (routing is a context problem), the mechanism (SessionStart hook), the release. Three posts minimum. Never mention the employer.

## Maintenance

Rerun `compass-audit` after any plugin install/removal. The audit skill rewrites the table and the compact injection file; the hook picks up changes on the next session start.
