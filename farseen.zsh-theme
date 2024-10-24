# Path segment: Display the current path with color #c6e3ff and white brackets
PROMPT=$'%{\e[38;5;153m%}[%{$fg[white]%}%~%{\e[38;5;153m%}] '

# Git segment: Add a newline and the git branch/status with icons and colors
PROMPT+=$'%{\n%}%{\e[38;5;153m%}\u2570\u2500 '  # New line, followed by └─ in #c6e3ff

# Git branch icon (\ue725) and branch name
ZSH_THEME_GIT_PROMPT_BRANCH_ICON=$'\ue725 '  # Custom branch icon

# Git information segment, showing branch and change statuses
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[white]%}] "
ZSH_THEME_GIT_PROMPT_DIRTY="%{\e[38;5;208m%}⚠"     # Orange warning indicator if the working directory is dirty
ZSH_THEME_GIT_PROMPT_CLEAN="%{\e[38;5;34m%}✔"       # Green checkmark for clean state

# Function to display the number of staged, changed, and untracked files with appropriate symbols and format
git_prompt_info() {
  local branch_name=$(git symbolic-ref --short HEAD 2>/dev/null)
  local staged_files=$(git diff --cached --name-only | wc -l | tr -d ' ')  # Count of staged files, remove spaces
  local changed_files=$(git diff --name-only | wc -l | tr -d ' ')           # Count of changed files, remove spaces
  local untracked_files=$(git ls-files --others --exclude-standard | wc -l | tr -d ' ')  # Count of untracked files, remove spaces

  if [ -n "$branch_name" ]; then
    local output="%{$fg[white]%}[$branch_name"  # Begin building the output with the branch name

    # Check if there are any status indicators (staged, changed, or untracked)
    local status_output=""
    if [ $staged_files -gt 0 ]; then
      status_output+=" %{\e[38;5;34m%}+${staged_files}%{$reset_color%}"  # Green +N for staged files
    fi
    if [ $changed_files -gt 0 ]; then
      status_output+=" %{\e[38;5;208m%}~${changed_files}%{$reset_color%}"  # Orange ~N for changed files
    fi
    if [ $untracked_files -gt 0 ]; then
      status_output+=" %{\e[38;5;196m%}?${untracked_files}%{$reset_color%}"  # Red ?N for untracked files
    fi

    # If there are any status indicators, add the separator (|) after the branch name
    if [ -n "$status_output" ]; then
      output+=" /${status_output}"
    fi

    output+="%{$fg[white]%}]"  # Close the square brackets

    echo -n "$output"  # Output the complete string without introducing new lines
  fi
}

# Combine the prompt with git info
PROMPT+=$'%{$fg[white]%}$(git_prompt_info) '

# Right prompt remains unused for now
RPROMPT=""
