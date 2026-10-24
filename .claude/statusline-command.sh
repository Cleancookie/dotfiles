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
AQUA=$(rgb FG 135 180 235)        # pastel cornflower blue
GOLD=$(rgb FG 210 190 120)        # muted gold
MUTED=$(rgb FG 150 150 165)       # dim separator

# ── Data extraction ───────────────────────────────────────────────────────────
project_dir=$(echo "$input" | jq -r '.workspace.project_dir // .workspace.current_dir // ""')
project_name=$(basename "$project_dir")

# Today's cost across all sessions
today=$(date +%Y-%m-%d)

_sum_cost() {
  find "$1" -name "*.jsonl" -mtime -1 2>/dev/null \
    | xargs -I{} sh -c 'jq -r --arg today "'"$today"'" "
        select(.timestamp | startswith(\$today))
        | .costUSD // (
            (.message.usage.input_tokens // 0) * 3 / 1000000 +
            (.message.usage.output_tokens // 0) * 15 / 1000000 +
            (.message.usage.cache_creation_input_tokens // 0) * 3.75 / 1000000 +
            (.message.usage.cache_read_input_tokens // 0) * 0.30 / 1000000
          )
      " "{}" 2>/dev/null' \
    | awk '{s+=$1} END {printf "%.4f", s+0}'
}

# usd = real dollar estimate, water = cooling-water joke
COST_UNIT=water
# Tongue-in-cheek guess, not a measurement
WATER_L_PER_USD=1.0

_fmt_cost() {
  case "$COST_UNIT" in
    usd) awk -v c="$1" 'BEGIN{printf "$%.2f", c}' ;;
    *)   awk -v c="$1" -v k="$WATER_L_PER_USD" 'BEGIN{printf "%.2fL", c*k}' ;;
  esac
}

today_cost=$(_fmt_cost "$(_sum_cost "$HOME/.claude/projects")")

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

limit_5h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // ""')
limit_7d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // ""')
reset_5h=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // ""')
reset_7d=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // ""')

# Time left until reset, e.g. 5d / 2h / 40m
fmt_left() {
  awk -v r="$1" -v n="$(date +%s)" 'BEGIN{
    s=r-n; if(s<0)s=0
    if(s>=172800) printf "%.0fd", s/86400
    else if(s>=3600) printf "%.0fh", s/3600
    else printf "%.0fm", s/60
  }'
}

# ── Separator ─────────────────────────────────────────────────────────────────
SEP="${RESET}${MUTED}${DIM} | ${RESET}"

# ── Render ────────────────────────────────────────────────────────────────────
# Segment 1: project  (lavender)
printf "${LAVENDER}${BOLD}📁 %s${RESET}" "$project_name"

# Segment 2: water usage  (aqua)
printf "${SEP}${AQUA}💧 %s used today${RESET}" "$today_cost"

# Segment 3: model + effort  (mint)
printf "${SEP}${MINT}🤖 %s${RESET}" "$model_str"

# Segment 4: session token totals  (sky blue)
printf "${SEP}${SKY}⬆ %s ⬇ %s${RESET}" "$in_str" "$out_str"

# Segment 5: context window usage  (peach)
printf "${SEP}${PEACH}🪟 %s/%s${RESET}" "$cur_str" "$ctx_str"

# Segment 6: usage limits  (muted gold)
if [ -n "$limit_5h" ] && [ -n "$limit_7d" ]; then
  printf "${SEP}${GOLD}📊 %s:%.0f%% %s:%.0f%%${RESET}" \
    "$(fmt_left "$reset_5h")" "$limit_5h" "$(fmt_left "$reset_7d")" "$limit_7d"
fi
printf "\n"
