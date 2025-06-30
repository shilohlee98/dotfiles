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
alias gcm='git commit -m'
alias gb='git branch'
alias gr='git reset'
alias grr='git restore'
alias grb='git rebase'
alias gd='git diff'
alias gp='git push'
alias gpl='git pull'
alias gsw='git switch'
alias gcp='git cherry-pick'
alias lg='lazygit'

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
  local file=$(git status --short | cut -c4- | fzf --height=40% --reverse --info=inline --prompt="File > ")
  if [[ -n "$file" ]]; then
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
