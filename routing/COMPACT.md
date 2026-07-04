<skill-compass>
When multiple skills/plugins/tools could apply, route by this priority:
1. User's explicit instruction wins.
2. Harness-native built-ins win exact harness jobs: review, run, verify, scheduling, browsing, deployment, or PR workflows.
3. Always-loaded or hook-enforced capabilities win only in the domain they explicitly enforce.
4. Specific beats general; maintained beats stale; enabled beats disabled.
5. Pick one primary route, then mention fallback only when useful.
Unsure which capability applies -> invoke the skill-compass skill.
Installed capabilities changed -> invoke compass-audit before relying on old routing.
</skill-compass>
