# Personal tool preferences

- Prefer `rg` over `grep` for searching text
- Prefer `fd` over `find` for locating files or directories
- Prefer `tree` for visualizing directory structure when available
- Use `jq` for JSON parsing
- Use `yq` for YAML parsing
- I use fish shell interactively, so be aware that shell syntax in my dotfiles may be fish syntax

# General working preferences

- Use English for all code, comments, documentation, examples, commit messages, configuration, error messages, and tests.
- Research the relevant code before editing. Never modify code you have not read, including nearby callers, exports, and shared utilities when relevant.
- State assumptions when they matter. Ask for clarification instead of guessing when requirements, intent, or existing design are unclear. Stop and restate uncertainty rather than proceeding blindly.
- Push back when the requested approach seems unnecessarily complex, risky, or over-engineered, and suggest a simpler alternative.
- Before or during implementation, identify what "done" means. Verify changes with the most relevant available checks, tests, or manual inspection.
- Do not use AI/model calls for deterministic logic such as routing, retries, status-code handling, parsing, validation, or mechanical transforms. Implement those with normal code.
- Write tests that verify the intended behavior and meaningful edge cases, not just superficial implementation details. Tests should fail when the important logic breaks.
- Follow existing codebase conventions even when they differ from personal preference. If a convention seems harmful, mention it instead of silently diverging.
- Be explicit about skipped work, missing checks, failing tests, assumptions, or uncertainty. Do not claim completion or passing tests if anything relevant was skipped or unverified.

# Coding style preferences

- Prefer strong invariants over defensive complexity. Make invalid states unrepresentable where practical, validate at boundaries, and avoid scattering fallback logic through the core implementation.
- Do not paper over unclear design with machinery. If the model, ownership, or state transitions are unclear, stop and clarify or simplify them before adding code.
- Fail loudly for programmer errors and impossible states instead of silently recovering. Add fallbacks only for real, expected runtime conditions, not to hide bugs or corrupt data.
- Avoid duplicating rules across call sites. Put each invariant or policy in one coherent place, with clear ownership and data flow.
- Do not default to "Clean Code" style patterns. Prefer locality and straightforward control flow over splitting code into many tiny functions.
- Keep implementations minimal, local, and direct. Avoid premature abstraction, indirection, layering, or generalized frameworks unless there is a clear, immediate benefit.
- Introduce abstractions only when they reduce real duplication/complexity, clarify ownership or boundaries, or enable a concrete requirement.
- Favor readable code that keeps related logic and data close together, in the spirit of Casey Muratori's critiques and *A Philosophy of Software Design*.
- Prioritize performance, security, and stability. Consider allocation behavior, error handling, input validation, failure modes, and edge cases.
- When modifying existing code, prefer the smallest coherent change that fits the surrounding style and avoids unnecessary churn.
- Avoid adding a dependency just to use one small feature or helper. If the needed functionality is small, isolated, and reasonable to maintain, strongly prefer copying or implementing that focused functionality locally instead of pulling in the dependency and its transitive dependencies. Preserve licenses/attribution when copying code.
