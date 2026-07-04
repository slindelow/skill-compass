---
name: skill-compass
description: Harness-aware routing table for installed skills, plugins, commands, agents, MCP servers, and built-ins. Use at the start of multi-step work, when two or more capabilities could plausibly apply, when unsure whether an installed capability exists, or when the user asks what to use for a task.
---

# Skill Compass

One rule above all: **the user's explicit instruction wins.** When several capabilities match, this table decides. When nothing matches, say so and proceed with the normal tools instead of forcing a route.

<!-- GENERATED: run compass-audit to replace the template below with this user's actual routing table. -->

## Priority Rules

1. **Harness built-ins win on exact harness jobs.** Use native review, run, verify, scheduling, browsing, or deployment tools when the harness wires them directly into the workflow.
2. **Hooked or always-loaded capabilities win in their domain.** If a capability injects session rules or is loaded as global memory, treat it as authoritative for the job it claims.
3. **Specific beats general.** A PR-review skill beats a generic review skill for PRs; a spreadsheet skill beats a generic data skill for workbook edits.
4. **Maintained beats stale.** Prefer capabilities that are installed, enabled, documented, and versioned over stray files or deprecated aliases.
5. **Pick one primary route.** If two capabilities are equivalent, choose one and note the fallback only when it matters.

## Route By Intent

Replace this section with `compass-audit` output. The generated version should group jobs by workflow stage and name exactly one primary capability per row:

| Situation | Use | Notes |
|---|---|---|
| Starting a feature or behavior change | `<primary planning/brainstorming capability>` | Use the harness's preferred planning flow. |
| Debugging a failure or unexpected behavior | `<primary debugging capability>` | Reproduce and isolate before proposing fixes. |
| Implementing code | `<primary implementation/TDD capability>` | Keep tests proportional to risk. |
| Reviewing local changes | `<native diff review capability>` | Prefer built-ins that can inspect the working tree. |
| Reviewing a pull request | `<native PR review capability>` | Prefer GitHub-aware or harness-native PR tooling. |
| Deep research | `<primary research capability>` | Use cited sources and verify freshness. |
| Documents, PDFs, slides, or spreadsheets | `<file-type-specific capability>` | Prefer specialized parsers and editors. |
| Memory or prior-work lookup | `<memory/context capability>` | Search previous work before re-solving. |
| Automation or recurring work | `<native automation capability>` | Use the harness mechanism for reminders, hooks, or scheduled runs. |

## Never Use

Populate this with:

- Broken skill files or invalid layouts.
- Deprecated aliases.
- Duplicative capabilities that lose every overlap.
- Personal or project-only routes that should not fire globally.

## Maintenance

Regenerate after installing, removing, enabling, or disabling capabilities. The audit should update this file, refresh `routing/COMPACT.md`, and stamp the current harness fingerprint when supported.
