# Claude.md

## Core Principles

Complexity is the enemy. The greatest limitation in writing software is our ability to understand the systems we create. All other principles stem from this.

Working code isn't enough. Your primary goal as a developer is to produce a great design that also happens to work, not just code that works.

DRY (Don't Repeat Yourself). Every piece of knowledge should have a single, unambiguous representation in the system. Duplication leads to maintenance nightmares and inconsistencies.

KISS (Keep It Simple, Stupid). Simplicity should be a key goal in design. Avoid unnecessary complexity and favor simple solutions that solve the problem effectively.

## Design Fundamentals

### Deep Modules

- Create modules with simple interfaces but powerful functionality
- The best modules provide powerful functionality yet simple interfaces
- Shallow modules (lots of interface, little functionality) increase complexity

### Information Hiding

- Each module should encapsulate knowledge that represents a design decision
- Hide implementation details behind clean abstractions
- Ask: "What is the simplest interface that covers my current needs?"

### Minimize Dependencies

- Modules should know as little as possible about other modules
- Avoid tight coupling between classes and modules
- Design interfaces that are self-contained

## Coding Practices

### Comments Are Crucial

- Write comments first - they help you think through the design
- Comments should describe things that aren't obvious from the code
- Good comments explain why, not what
- Update comments when you change code

### Error Handling

- Define errors out of existence when possible
- Aggregate errors rather than exposing each one
- Design APIs to minimize the chance of errors

### Naming

- Names should be precise and unambiguous
- If it's hard to name, the design is probably wrong
- Use names that explain what the code does, not how it does it

## Design Process

### Incremental Development

- Start with something simple that works
- Make a series of small improvements
- Each step should result in a working system

### Strategic vs. Tactical Programming

- Strategic: invest time to produce clean designs
- Tactical: focus only on making code work
- Always choose strategic programming - tactical programming leads to technical debt

### Code Review Guidelines

- Focus on design issues, not just bugs
- Ask: "Is this code easy to understand?"
- Look for unnecessary complexity and coupling

## Red Flags to Avoid

- Shallow modules - lots of interface, little functionality
- Information leakage - design decisions reflected in multiple places
- Temporal decomposition - splitting code based on when things happen
- Overexposure - making internal details visible
- Pass-through methods - methods that do nothing except pass parameters
- Repetition - same code pattern in multiple places
- Special-general mixture - general-purpose and special-purpose code mixed together

## Key Questions to Ask

- "What is the simplest interface that covers my current needs?"
- "What information can I hide in this module?"
- "How can I minimize dependencies between modules?"
- "Is this code easy to understand?"
- "Does this design minimize complexity?"

## Remember

- Complexity comes from dependencies and obscurity
- Good design reduces the amount of code that needs to be modified for typical changes
- The best way to reduce bugs is to make software simpler
- Consistency is a powerful tool for reducing complexity
