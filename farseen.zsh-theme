# Function to shorten the directory path
prompt_short_dir() {
  # Replace $HOME with ~ and abbreviate intermediate directories to single characters
  local dir_path="${PWD/#$HOME/~}"
  echo "${dir_path/#\//$HOME/}" | awk -F/ '{
    if (NF>3) { 
      printf "%s/…/%s", $2, $NF
    } else {
      print $0
    }
  }'
}

# Path segment: Display the current shortened path with color #c6e3ff and white brackets
PROMPT=$'%{\e[38;5;153m%}[%{\e[38;5;15m%}$(prompt_short_dir)%{\e[38;5;153m%}] '

# Git branch icon (\ue725) and branch name - properly escaped for ZSH
ZSH_THEME_GIT_PROMPT_BRANCH_ICON=$'%{\e[38;5;153m%}\ue725%{\e[38;5;15m%}'  # Custom branch icon

# Git information segment - colors for dirty, clean, and status indicators
ZSH_THEME_GIT_PROMPT_PREFIX="%{\e[38;5;15m%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="%{\e[38;5;15m%}]"
ZSH_THEME_GIT_PROMPT_DIRTY="%{\e[38;5;208m%}⚠"  # Orange warning for dirty status
ZSH_THEME_GIT_PROMPT_CLEAN="%{\e[38;5;34m%}✔"   # Green checkmark for clean status

# Git status function to replicate Oh-My-Posh logic
git_prompt_info() {
  # Check if the current directory is a Git repository
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    local branch_name=$(git symbolic-ref --short HEAD 2>/dev/null)  # Get current branch name
    local staged_files=$(git diff --cached --name-only | wc -l | tr -d ' ')  # Count staged files
    local changed_files=$(git diff --name-only | wc -l | tr -d ' ')          # Count changed files
    local untracked_files=$(git ls-files --others --exclude-standard | wc -l | tr -d ' ')  # Count untracked files

    # Start building the Git segment output
    local output="%{$fg[white]%}[$ZSH_THEME_GIT_PROMPT_BRANCH_ICON $branch_name"

    # Add indicators for staged, changed, and untracked files
    if [ $staged_files -gt 0 ]; then
      output+=" %{\e[38;5;34m%}● ${staged_files}"  # Green bullet for staged files
    fi
    if [ $changed_files -gt 0 ]; then
      output+=" %{\e[38;5;208m%}● ${changed_files}"  # Orange bullet for changed files
    fi
    if [ $untracked_files -gt 0 ]; then
      output+=" %{\e[38;5;196m%}● ${untracked_files}"  # Red bullet for untracked files
    fi

    # Close the Git segment
    output+="%{$fg[white]%}] "

    echo -n "$output"  # Output the complete Git segment
  fi
}

# Append Git info to the main prompt
PROMPT+=$'%{\e[38;5;15m%}$(git_prompt_info) '

# Right prompt (RPROMPT) remains unused
RPROMPT=""
