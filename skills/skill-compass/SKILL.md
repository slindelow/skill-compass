---
name: skill-compass
description: Routing table for every installed skill, plugin, agent, and built-in. Use at the start of any multi-step task, whenever two or more skills could plausibly apply, whenever unsure if an installed capability exists for the job, or when the user asks "what should I use for X". Resolves overlaps with explicit priority rules instead of guessing.
---

# Skill Compass — routing table

One rule above all: **user's explicit instruction > this table > guessing.** When several skills match, this table decides. When nothing matches, say so — don't force a skill.

## Priority rules (memorize these four)

1. **superpowers wins on process** (brainstorming, plans, TDD, debugging, verification) — it's rigid and hook-enforced by design.
2. **Built-ins win on their exact niche** (diff review, PR review, verify, run, scheduling, deep research, Claude API questions) — they're wired into the harness.
3. **engineering:\* wins for workplace artifacts** (ADRs, incident docs, standups, deploy checklists).
4. **agent-skills is the à-la-carte fallback** — use for its uniques, not for jobs rules 1–3 already cover.

## Route by intent

### Starting something
| Situation | Use |
|---|---|
| Building/changing any feature or behavior | `superpowers:brainstorming` FIRST, always |
| Ask is underspecified (no who/why) | `agent-skills:interview-me` |
| Idea is vague, needs stress-testing (not code yet) | `agent-skills:idea-refine` |
| Requirements clear, need a spec | `agent-skills:spec-driven-development` |
| Product-shaped feature → PRD | `ralph-skills:prd` (then `ralph` only if running the Ralph loop) |
| Spec exists, need implementation plan | `superpowers:writing-plans` (default) or `claude-mem:make-plan` when you want doc-discovery + subagent execution via `claude-mem:do` |
| Executing a written plan | `superpowers:executing-plans` / `superpowers:subagent-driven-development` |
| Work needs isolation | `superpowers:using-git-worktrees` |

### While building
| Situation | Use |
|---|---|
| Implementing any logic or bugfix | `superpowers:test-driven-development` |
| Any bug, failure, unexpected behavior | `superpowers:systematic-debugging` — before proposing fixes |
| High-stakes/unfamiliar code decision | `agent-skills:doubt-driven-development` |
| Coding against a framework/library | `agent-skills:source-driven-development` + `claude-api` (built-in) for anything Anthropic |
| UI work | `agent-skills:frontend-ui-engineering`, `anthropic-skills:ui-ux-pro-max` |
| Designing APIs/boundaries | `agent-skills:api-and-interface-design` |
| Change touches multiple files | `agent-skills:incremental-implementation` |

### Finishing
| Situation | Use |
|---|---|
| About to claim "done/fixed/passing" | `superpowers:verification-before-completion` — evidence first |
| Review working-tree diff | `/code-review` (built-in) |
| Review a GitHub PR | `/review` or `engineering:code-review` |
| Deep 5-axis review | `agent-skills:review` or the `code-reviewer` agent persona |
| Security pass | `/security-review` (built-in), `agent-skills:security-and-hardening`, `security-auditor` agent |
| Simplify without behavior change | `/simplify` (built-in) |
| See it actually work | `/verify`, `/run` (built-ins) |
| Branch is done | `superpowers:finishing-a-development-branch` |

### Memory & context (claude-mem)
| Situation | Use |
|---|---|
| "Did we solve this before?" | `claude-mem:mem-search` |
| New/unfamiliar codebase | `claude-mem:learn-codebase` (deep) or `claude-mem:smart-explore` (cheap, structural — prefer over reading whole files) |
| Project history / narrative | `claude-mem:timeline-report`, `claude-mem:weekly-digests` |
| Session quality degrading | `agent-skills:context-engineering` |

### Research & knowledge
| Situation | Use |
|---|---|
| Deep multi-source cited research | `deep-research` (built-in) |
| Anything Claude API/SDK/models/pricing | `claude-api` (built-in) — never from memory |
| Claude Code features/hooks/MCP questions | `claude-code-guide` agent |
| Mine own past work into a knowledge base | `claude-mem:knowledge-agent` |

### Data work
`data:analyze` (questions) → `data:explore-data` (new dataset) → `data:sql-queries` / `data:write-query` → `data:create-viz` → `data:build-dashboard`. Stats rigor: `data:statistical-analysis`.

### Workplace artifacts (engineering:*)
ADR/tech choice → `architecture` · system design → `system-design` · incident → `incident-response` · standup → `standup` · tech debt → `tech-debt` · test strategy → `testing-strategy` · deploy → `deploy-checklist` + `agent-skills:shipping-and-launch` · docs/runbooks → `documentation` + `agent-skills:documentation-and-adrs`

### Documents & files
PDF → `anthropic-skills:pdf` · Word → `docx` · slides → `pptx` · spreadsheets → `xlsx` · co-writing human docs → `doc-coauthoring` · slide-deck from one doc → `claude-mem:wowerpoint`

### Automation & harness
"From now on / whenever X" behaviors → `update-config` (hooks, NOT memory) · recurring runs → `/loop` (session) or `/schedule` (cloud cron) · keybindings → `keybindings-help` · new skills → `anthropic-skills:skill-creator` + `superpowers:writing-skills` · find more skills → `anthropic-skills:find-skills`

### Sofia-specific (vault sessions under Personal Assistant/)
| Situation | Use |
|---|---|
| ANY external writing (email, post, application) | `anthropic-skills:sofia-voice` first — non-negotiable |
| X content | `build-in-public` → `x-drafter` (never auto-post) |
| AI trend discovery / learning log | `learning-agent` |
| Career/network/outreach | `career-coach` + `network/contacts.md` |
| Pilates invoicing / class plans | `pilates-invoicing`, `video-to-action` |

## Never use
- `superpowers:brainstorm`, `superpowers:execute-plan`, `superpowers:write-plan` — deprecated aliases.
- `productivity:memory-management` for personal context — the Personal Assistant vault is the canonical system; this plugin is for generic workplace shorthand.
- Flat `*_SKILL.md` files in `~/.claude/skills/` — they don't load at all.

## Maintenance
Regenerate after installing/removing plugins: run the `compass-audit` skill (sibling in this plugin), which re-scans `~/.claude/plugins/installed_plugins.json`, project `.claude/skills/`, and the session skill list, then rewrites this table.
