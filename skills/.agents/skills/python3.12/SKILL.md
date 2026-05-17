# AGENT.md — Python 3.12 Coding Standards

## Tooling

- Formatter: `uv run ruff format`
- Linter: `uv run ruff check`
- Type checker: `uv run ty check`
- Tests: `uv run pytest`
- Package manager: `uv`, config in `pyproject.toml`
- Layout: `src/` layout

---

## Type Hints

- Annotate all function signatures.
- Use built-in generics. 
- Use `X | Y` union syntax. 
- Avoid `Any`. If unavoidable, add a comment explaining why.
- Prefer `Protocol` over `ABC` for structural typing.
- Use `typing.Self` for methods returning their own class.
- Use `@typing.override` when overriding parent methods.

---

## Data Modeling

- Use `@dataclass` for plain data containers.
- Use `frozen=True` for value objects and config.
- Use `slots=True` for performance-sensitive dataclasses.
- Never use mutable literals as default values — use `field(default_factory=...)`.
- Use Pydantic `BaseModel` when validation or serialization is needed.

---

## Control Flow

- Use `match/case` for shape- or type-based dispatch (replacing `if/isinstance` chains).
- Always include a `case _:` wildcard in `match` statements.
- Prefer early returns over deeply nested conditionals.
- Use `if/elif` for simple scalar equality checks — `match` is not a switch statement.

---

## Iteration

- Use `zip()` for parallel iteration.
- Use comprehensions for constructing collections.
- Use generators when you only need to iterate once — avoid materializing large sequences.
- Never manipulate indices manually when a built-in handles it.

---

## Error Handling

- Catch specific exception types — never use bare `except:`.
- Never silently swallow exceptions — always log them.
- Use `raise X from Y` to preserve exception chains.
- Use `contextlib.suppress` for intentional no-ops.
- Define a custom exception hierarchy rooted at a project-level base exception.
- Use `logging` for all output in library or application code.

---

## Resources & Files

- Always use `with` for resources (files, locks, connections).
- Use `pathlib.Path` for all filesystem operations. 

---

## Functions & Classes

- Reach for the standard library before adding a dependency.
- Keep functions short and single-purpose.
- Use keyword-only arguments (`*`) for clarity on functions with many parameters.
- Use `@property` instead of explicit getter/setter methods.
- Use `@classmethod` factory methods for complex construction — keep `__init__` simple.
- Prefer composition over inheritance.
- Use `functools.cache` for memoization.

---

## Concurrency

- Use `asyncio` for I/O-bound concurrency.
- Use `ProcessPoolExecutor` for CPU-bound parallelism.
- Avoid raw `threading` for new code.
