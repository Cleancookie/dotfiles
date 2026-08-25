Prefer using allowed tools in ~/.claude/settings.json
Prefer using right-sized subagents to keep current context down
Read files with Read, never cat/head/tail/sed -n via Bash. Grep to search, Glob to list. Piping command output through head/tail is fine (make check 2>&1 | tail -40)
Change existing files with Edit, not Write. Write is for new files — it carries the whole file body and that body stays in context for the rest of the session
Long sessions: when starting work that shares no state with what came before, say so and suggest /clear. Carried context is re-read every turn and costs more than model or effort choice
Try to follow good software principles: KISS, DRY, SOLID and to a lesser extent YAGNI
