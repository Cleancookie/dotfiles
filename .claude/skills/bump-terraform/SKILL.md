---
name: bump-terraform
description: Rebase a merged terraform branch onto main, bump the README retrigger counter, push, and open a PR so the terraform plan GitHub Action runs. Use when the user asks to "bump terraform", "retrigger terraform plan", "kick off the terraform workflow", or to reuse a merged branch in ~/projects/terraform to run a plan.
---

# Bump terraform (retrigger plan workflow)

The `~/projects/terraform` repo has a GitHub Action that runs `terraform plan` on PR events. When there are no real infra changes to PR, the team reuses an already-merged branch: reset it to `main`, bump the counter `Times updated just to retrigger workflows: X` in the README to produce a unique diff, and open a PR so the plan workflow fires.

## Inputs expected from the user

- **Branch name** — usually `<ticket>-<slug>` (e.g. `6563-home-switcher-internal-size`). The user typically just says the ticket number. If the current checked-out branch matches, use it; otherwise `git branch -a | grep <ticket>`.
- **Ticket number** — used in the commit message as `AB#<ticket>`. Derive from the branch name.

## Procedure

All commands run from `~/projects/terraform`.

### 1. Verify clean state and the branch is checked out

```bash
git status                    # must be clean
git branch --show-current     # should be the target branch; if not, git checkout it
```

If the tree is dirty, stop and ask the user — do not stash or discard without confirmation.

### 2. Fetch main and inspect divergence

```bash
git fetch origin main
git log --oneline -5 origin/main
git log --oneline -5 HEAD
```

Confirm the branch's work is already merged into main (you should see its commits reachable from `origin/main`, typically via a "Merge pull request #N from ..." commit). If the branch has unmerged work, stop and ask the user — don't silently throw away commits.

### 3. Reset branch to origin/main

```bash
git reset --hard origin/main
```

This is destructive but safe here because the branch's own work is already on main. The remote branch tip is an ancestor of the new HEAD, so the later push is a fast-forward, **not** a force-push.

### 4. Bump the counter in README.md

The counter lives at the bottom of `README.md`, line reads:

```
Times updated just to retrigger workflows: <N>
```

Increment N by 1. Use the Edit tool — do not rewrite the whole file.

### 5. Commit

Follow the G4C commit format (`AB#<ticket> <gitmoji> <desc>`). Use 📝 for docs/readme changes:

```bash
git commit -am "AB#<ticket> 📝 bump retrigger counter to kick off terraform plan"
```

Keep the body terse — one line is fine.

### 6. Push (fast-forward, no --force)

```bash
git push origin <branch-name>
```

If git rejects this as non-fast-forward, stop and investigate — something about the divergence assumption was wrong. **Do not** reach for `--force` without confirming with the user.

### 7. Open PR

```bash
gh pr create --base main --head <branch-name> \
  --title "AB#<ticket> 📝 bump retrigger counter to kick off terraform plan" \
  --body "$(cat <<'EOF'
## Summary
- Bump retrigger counter in README to force a non-empty diff on this branch so the terraform plan workflow runs.

## Test plan
- [ ] terraform plan workflow runs on this PR

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

`gh pr create` prints the PR URL on success — hand that back to the user.

## Guardrails

- Never force-push on this workflow. If push is rejected, the divergence assumption is wrong.
- Never skip hooks (`--no-verify`).
- If the user has in-progress local work on the branch (dirty tree or unmerged commits), stop and confirm before resetting.
- The counter bump is the *only* change this PR should contain. If the diff shows anything else, stop and investigate.
