Prefer using allowed tools in ~/.claude/settings.json
Prefer using right-sized subagents to keep current context down
Read files with Read, never cat/head/tail/sed -n via Bash. Grep to search, Glob to list. Piping command output through head/tail is fine (make check 2>&1 | tail -40)
Change existing files with Edit, not Write. Write is for new files — it carries the whole file body and that body stays in context for the rest of the session
Follow good software principles: KISS, DRY, SOLID, YAGNI, AHA.  Make design suggestions to encourage these principles
I am a visual learner please help me visualise things over a wall of text

# Commits

Use conventional commits but replacing the text with emojis
| Type | Gitmoji | Code | Description / Version Impact |
| :--- | :--- | :--- | :--- |
| `feat` | ✨ | `:sparkles:` | A new feature (**MINOR**) |
| `fix` | 🐛 | `:bug:` | A bug fix (**PATCH**) |
| `docs` | 📝 | `:memo:` | Documentation changes |
| `style` | 💄 | `:lipstick:` | Formatting, UI styling, missing semi-colons |
| `refactor` | ♻️ | `:recycle:` | Code change that neither fixes a bug nor adds a feature |
| `perf` | ⚡️ | `:zap:` | Code change that improves performance (**PATCH**) |
| `test` | ✅ | `:white_check_mark:` | Adding or updating tests |
| `build` / `ci` | 👷 / 💚 | `:construction_worker:` / `:green_heart:` | CI/CD build system or configuration changes |
| `chore` | 🔧 | `:wrench:` | Other changes that don't modify `src` or test files |
| `revert` | ⏪️ | `:rewind:` | Reverting a previous commit (**PATCH**) |
| `BREAKING CHANGE` | 💥 | `:boom:` | Breaking API changes (**MAJOR**) |
If there is a work item number attached to the work then it will prefix the emoji `AB#1234 ✨ add command palette`
The emoji replaces the type word — never write both. Format: [AB#1234 ]<emoji> <imperative subject>.
