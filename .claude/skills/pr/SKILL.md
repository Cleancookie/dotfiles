---
name: pr
description: Creates a pull request for G4C projects following house style. Looks up the Azure DevOps ticket via azure-boards-manager, builds a correctly structured PR body (AB#XXXX first line, terse lowercase bullets, Summary + optional Root cause/Why + Test plan, no emojis in body, no generated-by footer), and optionally moves the ticket to Active. Use when user says "make a PR", "raise a PR", "open a PR", or has finished a piece of work and wants to ship it.
---

# PR Skill

## Quick start

User says `/pr` or "make a PR" — infer ticket number from branch name or conversation, then follow the workflow below.

## Workflow

1. **Get ticket number** — from args, branch name (`git branch --show-current`), or conversation context
2. **Check for existing PR** — `gh pr list --head <branch> --json number,url` — if one exists, show it to the user and stop
3. **Look up ticket** — delegate to `azure-boards-manager` agent: fetch title, type, and state for that AB#
4. **Build PR body** — use the template below
5. **Push branch** — `git push -u origin <branch>` if not already pushed
6. **Create PR** — `gh pr create` targeting `main`, passing title and body via HEREDOC
7. **Wait for checks** — `gh pr checks <pr-number> --watch` — report pass/fail to user once complete
8. **Check on the Azure Boards ticket state** — if state is still New, let the user know and suggest that we can use the azure-boards-agent to update the state of it accordingly

## PR title format

```
AB#<ticket> <gitmoji> <short description>
```

Same gitmoji convention as commits (🐛 bug, ✨ feature, ♻️ refactor, etc.).

## PR body template

```
AB#<ticket>

## Summary
- <what changed, factual, lowercase>
- <second point if needed>

## Root cause / Why
- <for bugs: what caused it; for features: why it was needed>

## Test plan
- [ ] <concrete scenario>
- [ ] <second scenario>
```

**Rules:**
- `AB#XXXX` must be the very first line — the Azure Boards bot requires it in the body to auto-link
- Terse lowercase bullets only — no prose paragraphs, no bold field labels inside bullets
- Root cause/Why section is optional — include for bugs and non-obvious changes
- Test plan section is optional

## Notes

- Base branch is `main` for G4C repos
- If no ticket exists, omit the `AB#` line entirely but let the user know
