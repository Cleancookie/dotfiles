- Prefer using allowed tools in ~/.claude/settings.json
- Prefer using right-sized subagents to keep main thread current context down. Sonnet for scouting, research and coding tasks.  Haiku for very straight forward and short tasks.  Reserve Opus and above for more diffiult tasks.
- Before reading anything over ~200 lines into the main thread, ask:
  do I need the BYTES, or the CONCLUSION?
  Conclusion → Explore/general-purpose subagent, which returns prose and
  throws its own context away. Bytes → read only the line range you need.
- Grep to search, Glob to list. Piping command output through head/tail is fine (make check 2>&1 | tail -40)
- Change existing files with Edit, not Write. Write is for new files — it carries the whole file body and that body stays in context for the rest of the session
- Follow good software principles: KISS, DRY, SOLID, YAGNI, AHA.  Make design suggestions to encourage these principles
- I am a visual learner please help me visualise things over a wall of text
- Short sentences. RFC 2119 keywords for obligations. Commit = imperative subject; body only for a fact the diff cannot show. Comments only where code needs clarification - never narration

# Commits

Prefix commit messages with emojis.  These can be treated similarly to `conventional commits`
| Type | Gitmoji | Code | Description / Version Impact |
| :--- | :--- | :--- | :--- |
| `feat` | ✨ | `:sparkles:` | A new feature (**MINOR**) |
| `fix` | 🐛 | `:bug:` | A bug fix (**PATCH**) |
| `docs` | 📝 | `:memo:` | Documentation changes |
| `style` | 💄 | `:lipstick:` | Formatting, UI styling, missing semi-colons |
| `refactor` | ♻️ | `:recycle:` | Code change that neither fixes a bug nor adds a feature |
| `perf` | ⚡ | `:zap:` | Code change that improves performance (**PATCH**) |
| `test` | ✅ | `:white_check_mark:` | Adding or updating tests |
| `build` / `ci` | 👷 / 💚 | `:construction_worker:` / `:green_heart:` | CI/CD build system or configuration changes |
| `chore` | 🔧 | `:wrench:` | Other changes that don't modify `src` or test files |
| `revert` | ⏪️ | `:rewind:` | Reverting a previous commit (**PATCH**) |
| `BREAKING CHANGE` | 💥 | `:boom:` | Breaking API changes (**MAJOR**) |

If there is a work item number attached to the work then it will prefix the emoji `AB#1234 ✨ add command palette`
The emoji replaces the type word — never write both. Format: [AB#1234 ]<emoji> <imperative subject>.

# Commit message rules

**Subject only. No body unless direly needed.** If the subject cannot carry the
commit, the commit is doing too much — split it.

**Hard limit 450 characters, aim for 150.** Length is not the goal. A longer
subject that names the thing beats a short one that gestures at it.

**Name the thing.** Real function, file, endpoint or screen names. Say the trigger
a person would recognise, not the abstraction.

- ✅ `✨ add statRequest helper function which cancels stale http requests when date range filters are changed multiple times`
- ❌ `✨ add request helper` — which one, doing what?
- ❌ `🐛 fix bugs on dsj` — says nothing; unreadable in six months.

**Say what it's for, not how it's built.** State the outcome or the consumer it
unblocks. Field lists, query shapes and "instead of X" belong in the diff.

- ✅ `✨ add permissions to users so we can read view-crm-residential-sales-wallboards permission on portal_statistics_spa`
- ❌ `✨ add permissions field to graph User type returning direct and role-inherited permission names` — inventory of the diff, not the purpose
- ✅ `♻️ User.permissions no longer locked in to just strings`
- ❌ `♻️ return User.permissions as a Permission type with id, name, display_name and type instead of plain name strings`

**Lean on the commits around it.** A subject that explains itself is never wrong,
but when an earlier commit on the branch already set up the mechanism, prefer the
shorter subject that just says what this one does with it. Don't restate the same
rationale in every commit of a series.

- ✅ `🐛 move to use new statRequest function which stops stale request`
- also fine, just wordier once the helper's own commit has explained it:
  `🐛 fetch wallboard stats via statRequest so a slow old range cannot overwrite a new one`

**Reasoning, root cause and trade-offs go in the PR description, not the commits.**
