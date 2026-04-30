#!/bin/sh
input=$(cat)

# ── Pastel truecolour helpers ─────────────────────────────────────────────────
# Usage: rgb FG|BG r g b  →  escape sequence (no newline)
rgb() {
  layer=38; [ "$1" = "BG" ] && layer=48
  printf "\033[${layer};2;${2};${3};${4}m"
}
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"

# Pastel palette (truecolour)
LAVENDER=$(rgb FG 180 160 220)    # soft purple
MINT=$(rgb FG 140 210 180)        # mint green
PEACH=$(rgb FG 230 180 140)       # peach/apricot
ROSE=$(rgb FG 220 160 175)        # soft pink/rose
SKY=$(rgb FG 150 195 225)         # powder blue
GOLD=$(rgb FG 210 190 120)        # muted gold
MUTED=$(rgb FG 150 150 165)       # dim separator

# ── Data extraction ───────────────────────────────────────────────────────────
project_dir=$(echo "$input" | jq -r '.workspace.project_dir // .workspace.current_dir // ""')
project_name=$(basename "$project_dir")

# Today's cost across all JSONL files in the Claude projects dir for this workspace
today=$(date +%Y-%m-%d)
claude_proj_dir="$HOME/.claude/projects/$(echo "$project_dir" | sed 's|/|-|g')"
today_cost=$(find "$claude_proj_dir" -name "*.jsonl" -mtime -1 2>/dev/null \
  | xargs -I{} sh -c 'jq -r --arg today "'"$today"'" "
      select(.timestamp | startswith(\$today))
      | .costUSD // (
          (.message.usage.input_tokens // 0) * 3 / 1000000 +
          (.message.usage.output_tokens // 0) * 15 / 1000000 +
          (.message.usage.cache_creation_input_tokens // 0) * 3.75 / 1000000 +
          (.message.usage.cache_read_input_tokens // 0) * 0.30 / 1000000
        )
    " "{}" 2>/dev/null' \
  | awk '{s+=$1} END {printf "$%.2f", s+0}')

model=$(echo "$input" | jq -r '.model.id // ""' | sed 's/^claude-//')
effort=$(echo "$input" | jq -r '.effort.level // ""')
[ -n "$effort" ] && model_str="$model ($effort)" || model_str="$model"

total_in=$(echo  "$input" | jq -r '.context_window.total_input_tokens // 0')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')

cur_used=$(echo "$input" | jq -r '.context_window.current_usage | if . then (.input_tokens//0)+(.output_tokens//0)+(.cache_creation_input_tokens//0)+(.cache_read_input_tokens//0) else 0 end')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // 0')

# ── Formatting ────────────────────────────────────────────────────────────────
fmt_k() { echo "$1" | awk '{if($1>=1000) printf "%.0fk",$1/1000; else print $1}'; }
in_str=$(fmt_k "$total_in")
out_str=$(fmt_k "$total_out")
cur_str=$(fmt_k "$cur_used")
ctx_str=$(fmt_k "$ctx_size")

cost=$(echo "$input" | jq -r '.context_window.current_usage | if . then (.input_tokens//0)*3/1000000 + (.output_tokens//0)*15/1000000 + (.cache_creation_input_tokens//0)*3.75/1000000 + (.cache_read_input_tokens//0)*0.30/1000000 else 0 end' | awk '{printf "$%.3f",$1}')

# ── Separator ─────────────────────────────────────────────────────────────────
SEP="${RESET}${MUTED}${DIM} | ${RESET}"

# ── Render ────────────────────────────────────────────────────────────────────
# Segment 1: project  (lavender)
printf "${LAVENDER}${BOLD}📁 %s (today est: %s)${RESET}" "$project_name" "$today_cost"

# Segment 2: model + effort  (mint)
printf "${SEP}${MINT}🤖 %s${RESET}" "$model_str"

# Segment 3: session token totals  (sky blue)
printf "${SEP}${SKY}⬆ %s ⬇ %s${RESET}" "$in_str" "$out_str"

# Segment 4: context window usage  (peach)
printf "${SEP}${PEACH}🪟 %s/%s${RESET}" "$cur_str" "$ctx_str"

# Segment 5: cost  (muted gold)
printf "${SEP}${GOLD}💰 %s${RESET}\n" "$cost"
