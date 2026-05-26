---
name: ai-cleanup
description: Audit and clean up AI-generated codebase bloat — bandaid code, unnecessary abstractions, accretive complexity, and poor readability. Language-agnostic. Use when a codebase has grown through repeated AI edits without consolidation.
disable-model-invocation: true
---

# AI Codebase Cleanup

Audit a codebase that has grown through repeated AI-generated changes — where each edit added lines instead of replacing or consolidating, leaving behind bandaid code, redundant abstractions, and poor long-term maintainability.

The goal is a codebase a human can read, understand, and maintain without knowing its full history.

## Core Principle

Less code is better code. If two paths do the same thing, one is wrong. If an abstraction exists for one caller, it shouldn't exist. If a fix wraps a bug instead of removing it, unwrap it.

## Process

### 1. Explore

Use the Agent tool with `subagent_type=Explore` to walk the codebase. Look for friction — places where reading or changing one thing requires understanding many others. Explore organically and flag what you notice.

Focus on:

- **Accretive complexity**: code that grew by appending — conditions bolted onto existing functions, flags added to control existing behavior, fields added "just in case."
- **Bandaid code**: a fix that papers over a problem instead of solving it (null checks for values that should never be null, fallbacks masking a real error path, defensive `try/catch` around code that shouldn't fail).
- **Orphaned abstractions**: a class, function, or module extracted once and called exactly one place — can inlining it simplify things?
- **Duplicated logic**: two places doing the same thing because the second was written without reading the first.
- **Over-parameterized functions**: a function with booleans or enums controlling fundamentally different behaviors — it should be two functions.
- **Unnecessary indirection**: an adapter, wrapper, or helper that does nothing except rename or pass through — it costs comprehension without buying anything.
- **Dead code**: variables, functions, branches, or types that can never be reached, or that exist solely because a previous edit didn't clean up after itself.
- **Inconsistent style within a single file**: naming conventions, error handling patterns, or structure that changes between sections — a sign of accretion across multiple AI sessions.

### 2. Triage

Group findings into three buckets:

- **Delete** — code that can be removed outright (dead code, redundant abstractions, unnecessary wrappers)
- **Inline** — code that should be collapsed back into its call site (single-use extractions, one-liner helpers, shallow pass-throughs)
- **Simplify** — code that works but is harder to read than it needs to be (overly conditional flows, over-parameterized functions, excessive defensive checks)

Prioritize **Delete** and **Inline** over **Simplify** — removal is safer than rewriting.

### 3. Clean up

Work through the triage list. Prefer deletions over rewrites. Prefer inlining over restructuring. Only restructure when the simpler structure is obvious and strictly better.

**Guardrails:**
- Do not change behavior. If a simplification requires understanding a subtle invariant you're unsure about, skip it and flag it instead.
- Do not "improve" code outside your triage list.
- Match the style of surrounding code that is already clean — don't introduce new conventions.
- On large files, work in focused passes. Do not rewrite whole files in one go.

### 4. Report

After cleanup, give a short summary:
- What was deleted and why
- What was inlined and why
- What was simplified and how
- What was flagged but left alone, and what human decision it requires

Keep the summary under 10 bullet points. Do not pad it.
