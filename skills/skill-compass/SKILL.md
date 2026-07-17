---
name: skill-compass
description: Harness-aware routing table for installed skills, plugins, commands, agents, MCP servers, and built-ins. Use at the start of multi-step work, when two or more capabilities could plausibly apply, when unsure whether an installed capability exists, or when the user asks what to use for a task.
---

# Skill Compass

One rule above all: **the user's explicit instruction wins.** When several capabilities match, this table decides. When nothing matches, say so and proceed with the normal tools instead of forcing a route.

Generated for Sofia's Codex desktop capability surface on 2026-07-17. Re-run `compass-audit` after plugin, connector, or harness changes.

## Priority Rules

1. **User instruction wins.** A named skill, app, or workflow is primary for that turn.
2. **Scope rules win.** The nearest `AGENTS.md` and hook-enforced rules govern files, company data, approvals, and external actions.
3. **Current-session exposure wins.** Configured or cached capabilities are unavailable until their tools or skills are actually exposed in the running session.
4. **Codex-native wins exact harness jobs.** Use native web, automation, thread, plan, goal, editing, image, and desktop workflows.
5. **Specific beats general.** Use the most specific app, file-type, debugging, review, or domain skill.
6. **Primary runtime beats compatibility packs** for local documents, PDFs, slides, and spreadsheets.
7. **Pick one primary route.** Mention a fallback only when it changes the user's options.

## Route By Intent

### Understand and plan

| Situation | Primary route | Notes |
|---|---|---|
| Vague intent needing an executable spec | `spec` | Use before implementation when scope is genuinely unclear. |
| Ordinary multi-step plan | Native `update_plan` | Keep one step in progress. |
| Review an engineering plan | `plan-eng-review` | Use for architecture, sequencing, risk, and operability. |
| Review a visual or product design plan | `plan-design-review` | Use for layout and interaction decisions. |
| System architecture decision | `engineering:architecture` | Use `engineering:system-design` for a broader design. |
| Find prior company context | Nearest `AGENTS.md` routing | Use approved knowledge and operational systems only. |

### Research and inspect

| Situation | Primary route | Notes |
|---|---|---|
| Current facts or internet research | Native web tool | Cite authoritative sources. |
| Existing authenticated Chrome session | `chrome:control-chrome` | Best for user-owned logged-in browser state. |
| Isolated browser navigation or testing | `browser:control-in-app-browser` | Prefer for in-app browsing without Chrome state. |
| Non-browser Mac application | `computer-use:computer-use` | Use only when no direct app or file tool is better. |
| General GitHub orientation | `github:github` | Route to a more specific GitHub skill when one matches. |
| Connected Drive search or file lookup | `google-drive:google-drive` | Use exact Docs, Sheets, or Slides skill for editing. |

### Build and debug

| Situation | Primary route | Notes |
|---|---|---|
| Diagnose a code or system failure | `investigate` | Reproduce and isolate root cause. |
| Implement a normal code change | Native Codex tools | Follow project instructions and test in proportion to risk. |
| Write a technical design | `engineering:system-design` | Use `engineering:architecture` for an ADR. |
| Write SQL | `data:write-query` | Use `data:sql-queries` for dialect or optimization guidance. |
| Supabase work | `supabase:supabase` | Mandatory for any Supabase task. |
| Vercel or Next.js work | Most specific `vercel:*` skill | Use connected Vercel app when live platform state is needed. |
| Shopify Admin query design | `shopify-admin` when exposed | Do not use Storefront APIs for Admin analytics. |
| Shopify Admin execution by CLI | `shopify-use-shopify-cli` when exposed | If absent, report unavailable and use project-owned adapters only. |

### Review and verify

| Situation | Primary route | Notes |
|---|---|---|
| Review local changes before landing | `review` | Use `engineering:code-review` only as a general fallback. |
| Report-only QA | `qa-only` | Do not implement fixes unless asked. |
| Fix failing GitHub CI | `github:gh-fix-ci` | Inspect logs, fix locally, and verify checks. |
| Address PR review comments | `github:gh-address-comments` | Use thread-level GitHub context when required. |
| Verify a Vercel web app | `vercel:verification` | Use browser verification for the rendered app. |
| Validate analysis before sharing | `data:validate-data` | Check methodology, accuracy, and bias. |
| Pre-deployment readiness | `engineering:deploy-checklist` | Use before shipping a release. |

### Create artifacts and visuals

| Situation | Primary route | Notes |
|---|---|---|
| Local Word document | `documents:documents` | Primary-runtime route. |
| Local PDF | `pdf:pdf` | Use for reading, creating, rendering, and visual QA. |
| Local PowerPoint deck | `presentations:Presentations` | Primary-runtime route. |
| Local spreadsheet | `spreadsheets:Spreadsheets` | Use data skills for analysis inside the workflow. |
| Google Doc, Sheet, or Slides file | Matching `google-drive:*` skill | Keep the connected Drive file as source of truth. |
| Raster image generation or edit | `imagegen` | Use the native image generation tool. |
| Interactive visualization | `visualize:visualize` | Use only when interaction adds real value. |
| Website creation and hosting | `sites:sites-building`, then `sites:sites-hosting` | Hosting must follow building. |

### Communicate and operate

| Situation | Primary route | Notes |
|---|---|---|
| Draft or send Slack content | `slack:slack-outgoing-message` | In Work, exact Sofia approval and agent disclosure are mandatory for sends. |
| Draft a Slack reply | `slack:slack-reply-drafting` | Do not send without action-time approval. |
| Gmail work | `gmail:gmail` | Use inbox triage for prioritization. |
| Calendar work | Most specific `google-calendar:*` skill | Live changes require clear user intent. |
| Recurring task or reminder | Native Codex automation tool | Do not route to Claude's cached schedule skill. |
| Manage Codex tasks | Native thread tools | Use subagents only when instructions explicitly call for them. |
| Company operational state | Company doctrine, then approved typed MCP | Never bypass with raw database access. |

## Never Use

- Cached `anthropic-skills/schedule`: its YAML frontmatter is malformed, and native Codex automations are primary.
- Heatmap or Shopify Storefront MCPs when they are merely configured but not exposed in the current session.
- Shopify Storefront access for orders, customers, revenue, Admin analytics, or other private store data.
- Raw database or service-role access for company operational systems.
- Compatibility-pack artifact skills when the primary-runtime skill handles the local file.
- Any external send, destructive action, or production mutation without the authorization required by the nearest context rules.

## Maintenance

Regenerate after installing, removing, enabling, or disabling capabilities. Restart Codex first when plugin exposure changed. Update this file and `routing/COMPACT.md`; stamp the fingerprint only after Sofia accepts the generated table.
