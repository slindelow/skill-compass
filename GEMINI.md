# Skill Compass

Use skill-compass when multiple Gemini CLI extensions, skills, commands, MCP servers, sub-agents, hooks, or built-ins could apply.

Routing priority:

1. The user's explicit instruction wins.
2. Gemini built-ins and native commands win exact Gemini workflow jobs.
3. Always-loaded extension context and hooks win only in the domains they explicitly enforce.
4. Specific beats general; maintained beats stale; enabled beats disabled.
5. Pick one primary route and mention a fallback only when useful.

If installed capabilities changed, invoke the `compass-audit` skill before relying on an old routing table.
