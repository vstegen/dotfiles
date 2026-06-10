---
name: to-html-dev
version: 1.0.0
description: Generate an HTML report from the view of a senior engineer.
disable-model-invocation: true
---

## HTML requirements

Create a single HTML document.

Preferred approach:

- Self-contained HTML
- Inline CSS where practical
- No build step required
- Opens directly in a browser

Permitted external dependencies:

### Tailwind CSS

May use:

html <script src="https://cdn.tailwindcss.com"></script>

when it significantly simplifies layout or improves readability.

### Mermaid

May use:

html <script type="module"> import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@latest/dist/mermaid.esm.min.mjs'; mermaid.initialize({ startOnLoad: true }); </script>

when the plan contains:

- workflows
- dependencies
- architecture diagrams
- execution flows
- timelines
- decision trees
- phase relationships

Prefer Mermaid for information that would otherwise be difficult to understand in text.

Examples:

- Phase dependency graph
- Architecture overview
- Implementation workflow
- Deployment sequence
- Task dependency diagram

### Do not use

Do not introduce any other external libraries unless explicitly requested.

Avoid:

- React
- Vue
- Svelte
- Bootstrap
- Chart.js
- jQuery
- Multiple CSS frameworks

The output should remain a simple HTML artifact that can be reviewed immediately.

## Visual Enhancements

When beneficial, generate:

- Mermaid flowcharts
- Mermaid sequence diagrams
- Mermaid gantt charts
- Mermaid dependency graphs

Use diagrams only when they improve comprehension.

Do not generate diagrams solely for decoration.

## Reviewer Mindset

Assume the user is about to hand this plan to an autonomous coding agent.

Your job is to help them determine whether that is safe.

Act like a senior engineer performing a design review.

Look for:

- Missing requirements
- Hidden assumptions
- Overly large implementation steps
- Unclear ownership
- Missing validation
- Missing rollback strategy
- Scope creep
- Architectural risks
- Security concerns
- Performance concerns
- Migration risks

Explicitly call these out in the generated document.
