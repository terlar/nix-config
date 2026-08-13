---
name: ast-grep
description: Use when searching for CODE STRUCTURE or PATTERNS (functions, classes, method calls, imports, hooks, error handling, async patterns, parameter counts) in JavaScript, TypeScript, Python, Rust, Go, Java, C, Ruby, PHP, Nix. Understands code syntax and structure. NOT for plain text search (TODO comments, string literals, simple text patterns) — use grep for those.
---

# ast-grep Structural Code Search

## Overview

This skill enables structural code search using Abstract Syntax Tree (AST) patterns via the ast-grep MCP server. Unlike text-based search (grep), ast-grep understands code structure, allowing precise queries like "find async functions without error handling" or "locate functions with >3 parameters".

## When to Use This Skill

**Use ast-grep for structural/semantic queries:**
- Code constructs: "find all functions/classes/imports/exports"
- Structural relationships: "functions that call X", "methods inside class Y"
- Semantic patterns: "async without await", "missing error handling", ">N parameters"
- Language-specific: "React hooks in useEffect", "SQL injection patterns"
- Context-aware: "console.log inside class methods"

**Use grep for text search:**
- Plain text: "TODO comments", "FIXME", "deprecated"
- String literals: "find error messages containing X"
- Simple regex: "email addresses", "URLs"
- Non-code files: markdown, JSON, config files

## Workflow

### 1. Understand the Query

Clarify the search requirements:
- What code structure? (function, class, call, import, assignment)
- Which language? (javascript, typescript, python, rust, go, etc.)
- Structural constraints? (inside X, has Y, without Z)
- Edge cases to consider?

### 2. Create Example Code

Write a minimal code snippet that represents what should match. This will be used for testing the rule.

**Example:** For "async functions that use await":
```javascript
// test_example.js
async function example() {
  const result = await fetchData();
  return result;
}
```

### 3. Write the ast-grep Rule

Translate the pattern into an ast-grep rule. **Start with simple patterns first**, only use `kind` for complex nested structures.

**Decision tree:**
1. **Can you write the code literally?** → Use `pattern`
2. **Need to match variations?** → Add metavariables (`$VAR`, `$$$ARGS`)
3. **Need structural constraints?** → Add `has`/`inside`/`not`
4. **Still not working?** → Use `dump_syntax_tree`, then try `kind`

**Start here (simple pattern):**
```yaml
id: async-with-await
language: javascript
rule:
  pattern: async function $NAME($$$) { $$$ }
```

**Only escalate to `kind` if pattern fails:**
```yaml
id: complex-nested
language: javascript
rule:
  all:
    - kind: function_declaration
    - has:
        pattern: await $EXPR
        stopBy: end
```

**Key principles:**
- Pattern first — matches exactly what you see in code
- Multiple conditions? Use `all: [...]`, not duplicate `has:`
- Relational rules (`has`, `inside`) require `stopBy: end`
- Test with `dump_syntax_tree` only when pattern doesn't match

See `references/rule_reference.md` for comprehensive rule syntax documentation.

### 4. Test the Rule

**Use the `ast-grep_test_match_code_rule` MCP tool** to validate before searching the full codebase:

```json
{
  "rule": "id: test\nlanguage: javascript\nrule:\n  kind: function_declaration\n  has:\n    pattern: await $EXPR\n    stopBy: end",
  "code": "async function example() { const x = await fetch(); }"
}
```

**If no matches:**
1. **Start simpler** — remove conditions one by one
2. **Use `pattern` instead of `kind`** — write code literally with metavariables
3. **Check for duplicate fields** — use `all: [...]` for multiple `has`/`inside`
4. **Verify `stopBy: end`** on relational rules (`has`, `inside`)
5. **Inspect AST** — use `dump_syntax_tree` to see actual structure
6. **Last resort: `kind`** — use when pattern fundamentally can't express it

### 5. Search the Codebase

Once the rule matches the example correctly:

**For simple patterns:**
Use `ast-grep_find_code` tool:
```json
{
  "pattern": "console.log($$$ARGS)",
  "language": "javascript",
  "output_format": "text"
}
```

**For complex rules:**
Use `ast-grep_find_code_by_rule` tool:
```json
{
  "rule": "id: my-rule\nlanguage: javascript\nrule:\n  kind: function_declaration\n  has:\n    pattern: await $EXPR\n    stopBy: end",
  "output_format": "text",
  "max_results": 50
}
```

**Output format:**
- `"text"` (default) — compact, ~75% fewer tokens, grep-like output
- `"json"` — full metadata, use only when you need metavariable extraction or precise ranges

## MCP Tools

### `ast-grep_find_code`

Simple pattern search for straightforward structural matches.

**Parameters:**
- `pattern` (required): ast-grep pattern with metavariables (e.g., `console.log($ARG)`)
- `language` (required): target language (javascript, typescript, python, rust, go, etc.)
- `output_format` (optional): `"text"` (default) or `"json"`
- `max_results` (optional): limit number of matches returned

**Example:**
```json
{
  "pattern": "function $NAME($$$) { $$$ }",
  "language": "javascript",
  "output_format": "text"
}
```

### `ast-grep_find_code_by_rule`

Advanced rule-based search with complex matching logic.

**Parameters:**
- `rule` (required): YAML rule content as a string
- `output_format` (optional): `"text"` (default) or `"json"`
- `max_results` (optional): limit number of matches returned

**Example:**
```json
{
  "rule": "id: async-no-try\nlanguage: javascript\nrule:\n  pattern: async function $NAME($$$) { $$$ }\n  not:\n    has:\n      pattern: try { $$$ }\n      stopBy: end",
  "output_format": "text"
}
```

### `ast-grep_test_match_code_rule`

Test a rule against example code before searching the entire codebase.

**Parameters:**
- `rule` (required): YAML rule string to test
- `code` (required): code snippet to match against

**Returns:** Matches found in the test code (empty if no matches)

**Use this to:**
- Validate rules work as expected
- Iterate on rule development
- Debug complex matching logic

**Example:**
```json
{
  "rule": "id: test\nlanguage: javascript\nrule:\n  pattern: console.log($ARG)",
  "code": "console.log('hello'); console.error('nope');"
}
```

### `ast-grep_dump_syntax_tree`

Inspect the AST structure of code to understand node types and structure.

**Parameters:**
- `code` (required): code snippet to inspect
- `language` (required): target language

**Use this to:**
- Find correct `kind` values for AST nodes
- Understand code structure for complex patterns
- Debug why patterns aren't matching

**Example:**
```json
{
  "code": "class User { constructor() {} }",
  "language": "javascript"
}
```

## Rule Writing Reference

### Metavariables

- `$VAR` — matches a single node (expression, statement, identifier)
- `$$$VARS` — matches zero or more nodes (variadic)

**Example:**
```yaml
pattern: function $NAME($$$PARAMS) { $$$BODY }
```

### Relational Rules

Match code based on structural relationships:

- `has: { pattern: X, stopBy: end }` — contains X anywhere inside
- `inside: { pattern: Y, stopBy: end }` — is inside Y
- `precedes: X` — comes before X in source order
- `follows: X` — comes after X in source order

**Always include `stopBy: end`** to search to the end of the scope.

**Example:**
```yaml
rule:
  kind: function_declaration
  has:
    pattern: await $EXPR
    stopBy: end
```

### Composite Logic

Combine rules using boolean operators:

- `all: [rule1, rule2, ...]` — AND (all must match) — **use for multiple `has`/`inside`**
- `any: [rule1, rule2, ...]` — OR (at least one matches)
- `not: { rule }` — negation (must not match)

**Critical: Use `all` for multiple conditions, never duplicate `has`/`inside` fields.**

**Example:**
```yaml
rule:
  all:
    - pattern: async function $NAME($$$) { $$$ }
    - has:
        pattern: await $EXPR
        stopBy: end
    - not:
        has:
          pattern: try { $$$ }
          stopBy: end
```

## Examples

### Find Async Functions Without Error Handling

**Pattern-first approach (recommended):**
```yaml
id: async-no-try
language: javascript
rule:
  pattern: async function $NAME($$$) { $$$ }
  not:
    has:
      pattern: try { $$$ }
      stopBy: end
```

### Find Nix Bindings with Specific Value

```yaml
id: enabled-services
language: nix
rule:
  pattern: "{ $A = true; }"
```

Matches: `{ programs.opencode.enable = true; }`  
`$A` captures: `programs.opencode.enable` (full attrpath)

### Find Nix Function Definitions

```yaml
id: nix-lambdas
language: nix
rule:
  pattern: "$A: $B"
```

Matches: `x: x + 1`, `name: version: src: ...`

### Find Functions with More Than 3 Parameters

```yaml
id: many-params
language: typescript
rule:
  pattern: function $NAME($A, $B, $C, $D, $$$) { $$$ }
```

### Find React Hooks Inside useEffect

```yaml
id: hook-in-effect
language: typescript
rule:
  inside:
    pattern: useEffect(() => { $$$ })
    stopBy: end
  pattern: use$HOOK($$$)
```

### Find Console Logs in Class Methods

```yaml
id: log-in-method
language: javascript
rule:
  inside:
    kind: method_definition
    stopBy: end
  pattern: console.log($$$)
```

## Tips

1. **Pattern first, `kind` last** — write code literally with `$VAR`, only use `kind` when pattern can't express it
2. **Test first** — always use `test_match_code_rule` before searching the full codebase
3. **Use `all` for multiple conditions** — never duplicate `has`/`inside` fields
4. **Add `stopBy: end`** to relational rules (`has`, `inside`)
5. **Prefer text format** — use `output_format: "text"` for efficiency (default)
6. **Limit results** — set `max_results` for exploratory searches to avoid token bloat

## Debugging

**Pattern not matching:**
1. **Try simpler pattern** — remove metavariables, match exact code first
2. **Check for YAML errors** — duplicate `has` fields? Missing `all:`?
3. **Inspect AST** — use `dump_syntax_tree` to see structure
4. **Verify `stopBy: end`** on `has`/`inside` rules
5. **Last resort: `kind`** — check AST node names match language

**Duplicate field errors (`has`, `inside`, etc.):**
```yaml
# ❌ Wrong - duplicate `has`
rule:
  has: { pattern: X }
  has: { pattern: Y }

# ✅ Correct - wrap in `all`
rule:
  all:
    - has: { pattern: X, stopBy: end }
    - has: { pattern: Y, stopBy: end }
```

**Too many false positives:**
1. Add `not` constraints to exclude unwanted matches
2. Add structural constraints with `inside` or `has`
3. Use more specific patterns (fewer metavariables)

**No results but code exists:**
1. Test rule with `test_match_code_rule` first
2. Check language specification matches file type
3. Verify pattern syntax is valid code for that language

## Supported Languages

ast-grep supports many languages including:
- JavaScript, TypeScript
- Python
- Rust
- Go
- Java, Kotlin
- C, C++, C#
- Ruby
- PHP
- Nix
- And many more

See full list: https://ast-grep.github.io/reference/languages.html

### Language-Specific Notes

**Nix:**
- Attrpaths are single metavariables: `$A` matches full path like `programs.opencode.enable`
- Bindings: `{ $A = $B; }` matches `{ programs.opencode.enable = true; }`
- Can't use dot notation in patterns: `$A.enable = $B` **doesn't work**
- Functions: `$A: $B` matches lambda, `{ $A, $B }: $C` matches attribute set pattern
- Lists: `[ $$$ITEMS ]` matches any list elements
- Let expressions: `let $A = $B; in $C`
- With expressions: `with $A; $B`
- Working examples from ast-grep tests:
  ```yaml
  # Match any binding with specific value
  pattern: "{ $A = true; }"     # Matches { enable = true; }
  
  # Match function definitions
  pattern: "$A: $B"             # Matches x: x + 1
  
  # Match attribute set functions
  pattern: "{ $A, $B }: $C"     # Matches { foo, bar }: foo + bar
  ```

**JavaScript/TypeScript:**
- `async` is a sibling of `function_declaration`, not inside it
- Use `pattern: async function $NAME() {}` not `kind: function_declaration` + `has: async`
- Arrow functions: `($$$) => $EXPR` or `$VAR => $EXPR`
- Imports: `import { $$$NAMES } from '$MODULE'`

**Python:**
- Indentation matters in patterns — match exact indentation or use `kind` for flexibility
- Decorators: `@$DECORATOR\ndef $NAME($$$): $$$`
- Type hints: `def $NAME($$$) -> $TYPE: $$$`
- Comprehensions: `[$EXPR for $VAR in $ITER]`

**Common pitfalls:**
- Keywords as siblings (async, const, let) — use pattern with keyword, not `has: pattern: keyword`
- Nix attrpaths — `$A` matches full path, can't split with dots in pattern
- Nested structures — pattern works better than multiple `kind` + `has`
- Language-specific syntax (decorators, attributes, macros) — check AST with `dump_syntax_tree` first

For comprehensive rule syntax and advanced patterns, see `references/rule_reference.md`.
