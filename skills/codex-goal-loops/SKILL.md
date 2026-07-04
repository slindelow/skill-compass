---
name: codex-goal-loops
description: Draft, refine, and manage Codex Goals for long-running loop-style work. Use when the user says "loop", "keep going", "continue until done", "use goals", "turn this into a /goal", or asks Codex to persistently work on performance tuning, flaky tests, benchmark-driven fixes, migrations, research audits, reproductions, or any task where the next step depends on evidence gathered along the way.
---

# Codex Goal Loops

Use Goals when the user wants persistent, evidence-checked progress toward a finish line, not just the next action. A Goal is a thread-scoped completion contract: outcome, verification, constraints, iteration policy, and blocker conditions.

## Decision Rule

Use a normal prompt when the task is a one-off edit, explanation, or command.

Use a Goal when the user would otherwise need to say:

- "keep going"
- "try the next likely fix"
- "rerun the benchmark"
- "continue until this is actually done"
- "stop only when we have evidence or a real blocker"

Good Goal candidates: performance optimization, flaky test investigation, reproduction work, dependency migrations, multi-step refactors, benchmark-driven tuning, research audits, generated artifacts that need build/validation, and debugging where each result determines the next experiment.

## Draft The Goal

When the user asks for help creating a Goal, produce a copy-pasteable `/goal` command. Do not start the Goal unless the user explicitly asks you to.

Strong Goals include:

1. **Outcome:** what must be true when done.
2. **Verification surface:** tests, benchmarks, logs, artifacts, reports, command output, or source evidence.
3. **Constraints:** what must not regress or change.
4. **Boundaries:** allowed files, tools, repos, data, or scope.
5. **Iteration policy:** how to choose and report the next experiment.
6. **Blocked stop condition:** when to stop and what evidence to report.

Template:

```text
/goal <desired end state>, verified by <specific evidence>, while preserving <constraints>. Use <allowed scope/tools>. Between iterations, <record what changed, what evidence showed, and the next best action>. If blocked or no valid paths remain, stop with <attempts, evidence, blocker, and next input needed>.
```

## Activate Carefully

If the user explicitly asks you to start a Goal and the `create_goal` tool is available, create it with the exact objective. Use a token budget only when the user explicitly gives one.

If the Goal is underspecified, draft a stronger version first and ask for approval before creating it when a bad assumption would be risky. If reasonable defaults are obvious, state them and proceed.

Never mark a Goal complete unless concrete evidence satisfies the objective. Budget exhaustion, partial progress, or "probably fixed" is not completion.

## Examples

Performance:

```text
/goal Reduce p95 checkout latency below 120 ms, verified by the checkout benchmark, while keeping the correctness suite green. Use only the checkout service, benchmark fixtures, and related tests. Between iterations, record what changed, what the benchmark showed, and the next best experiment. If the benchmark cannot run or no valid paths remain, stop with attempted paths, evidence, blocker, and next input needed.
```

Flaky test:

```text
/goal Make the flaky checkout test pass reliably on the current branch, verified by reproducing the failure or running the targeted test repeatedly, while preserving public API behavior. Use the test, fixtures, and directly related implementation code. Between iterations, record the observed failure mode, the hypothesis tested, and the next likely cause. If the failure cannot be reproduced or no defensible fix remains, stop with evidence and what would unlock progress.
```

Docs/artifact:

```text
/goal Produce a Goals documentation page that explains lifecycle commands, completion criteria, and two examples, verified by the local docs build and command references, while preserving existing docs style. Use the docs directory and related config only. Between iterations, run the smallest useful validation and fix the highest-confidence issue. If the build cannot run, stop with the command attempted, error, and next input needed.
```

Research:

```text
/goal Produce the strongest evidence-backed reproduction report for the target paper using available materials and local resources. Attempt headline results where feasible, verify outputs where possible, and end with a report separating confirmed findings, approximate reconstructions, blocked claims, and remaining uncertainty. If exact reproduction is not possible, document why and what evidence would be needed.
```

## Lifecycle Reminders

Useful user-facing commands:

```text
/goal          View the current Goal
/goal pause    Pause an active Goal
/goal resume   Resume a paused Goal
/goal clear    Remove the current Goal
```

When a Goal is active, keep continuation evidence-based:

- Compare progress to the objective before deciding done.
- Continue only when the next action is supported by the latest evidence.
- Stop and report blockers when no defensible path remains under current limits.
- Summarize progress clearly when budget or lifecycle state stops further work.
