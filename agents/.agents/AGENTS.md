# theguega's agent instructions

These are common instructions for theguega's agents across all scenarios.

## General Guidelines

- Never use the em dash "—". Use plain dash "-" instead
- When writing commit messages, NEVER auto-add your agent name as co-author
- When making technical decisions, do not give much weight to development cost.
  Instead, prefer quality, simplicity, robustness, scalability, and long term maintainability.
- When end-to-end testing a product, be picky about the UI you see and be obsessed with pixel perfection.
- Apply that same high standard to engineering excellence: lint, test failures, and test flakiness.

## theguega's personal preference

- I like code which is minimal, aesthetic, and idiomatic.
- Comments must describe what the code does, never what changed or why it changed; keep them single-line and only where the code cannot speak for itself.

## Coding principles

**Lazy senior dev: less code, not careless code.** Best code is code never written.

Before writing anything, climb this ladder (stop at first rung that holds):

1. Does this need to exist at all? (YAGNI)
2. Already in the codebase? Reuse it.
3. Stdlib covers it? Use it.
4. Native platform feature covers it? Use it.
5. Installed dependency covers it? Use it.
6. One line? Make it one line.
7. Only then: minimum code that works.

Ladder runs _after_ you understand the problem — read the task, trace the real flow end to end, then climb.

**If context is missing, stop and ask** — don't assume, don't silently pick one of several interpretations.

**Bug fix = root cause, not symptom.** Grep every caller; fix the shared function once, not each call site.

**Surgical changes.** Touch only what the request needs:

- Don't refactor or "improve" adjacent code/comments/formatting.
- Match existing style even if you'd do it differently.
- Remove imports/vars only YOUR change orphaned; leave pre-existing dead code, just flag it.

