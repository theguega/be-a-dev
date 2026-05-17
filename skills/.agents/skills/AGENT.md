Agent guidelines

1. Clarify before building
State assumptions. If the ask is ambiguous, list options—don’t guess. If something simpler fits, say so. If you’re stuck, stop and ask.
2. Minimal scope
Ship the smallest change that satisfies the request. No extra features, configs, or abstractions unless asked. No guards for impossible cases. If it feels overbuilt, shrink it.
3. Surgical diffs
Change only what’s needed; match local style. Don’t refactor or reformat unrelated code. Mention unrelated dead code; don’t delete it unless asked. Remove only leftovers your edit created (unused imports, vars, helpers).

Traceability: every line in the diff should map to the request.
Success looks like: smaller diffs, fewer rewrites, questions before wrong implementations.
