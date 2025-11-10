export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

alias v='nvim'

alias t='tmux'
alias ta='tmux a'
alias tl='tmux ls'

alias gl='git log'
alias gl1='git log --oneline'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gcm='git commit -m'
alias gb='git branch'
alias grs='git reset'
alias grr='git restore'
alias grb='git rebase'
alias gd='git diff'
alias gfo='git fetch origin'
alias gp='git push'
alias gpo='git push origin'
alias gpl='git pull'
alias gsw='git switch'
alias gcp='git cherry-pick'
alias lg='lazygit'

alias vj='jq . | nvim -c "set ft=json | set syntax=on | setlocal buftype=nofile bufhidden=wipe noswapfile" -'

jf() {
  echo "$1" | yq -oj eval .
}

jfe() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: jfe '<yq expression>' '<json string>'"
    return 1
  fi
  echo "$2" | yq -oj eval "$1" -
}

__fzf_git_branch_insert() {
  local branch=$(git branch | sed 's/^..//' | sort -u | fzf --height=40% --reverse --info=inline --prompt="Branch > ")
  if [[ -n "$branch" ]]; then
    LBUFFER+="$branch"
    zle reset-prompt
  else
    zle redisplay
  fi
}

__fzf_git_status_file_insert() {
  local result
  result=$(git status --short | fzf --height=40% --reverse --info=inline --prompt="File > ")
  if [[ -n "$result" ]]; then
    local file="${result##?? }"
    LBUFFER+="$file"
    zle reset-prompt
  else
    zle redisplay
  fi
}

zle -N __fzf_git_status_file_insert
bindkey '^F' __fzf_git_status_file_insert
zle -N __fzf_git_branch_insert
bindkey '^G' __fzf_git_branch_insert


alias y='yazi'

alias cw='cd ~/workspace'

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
export EDITOR='nvim'

# zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  alias cd='z'
fi

# python source with uv venv 
alias psv="source .venv/bin/activate" 

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export PATH='~/.duckdb/cli/latest':$PATH

export PATH="/Library/TeX/texbin:$PATH"
