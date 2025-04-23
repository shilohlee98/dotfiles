cd ~/dotfiles

stow -t ~/.config -S nvim
stow -t ~/.config -S yazi
stow -t ~/.config -S ghostty
stow tmux
stow zsh

source ~/.zshrc
tmux source-file ~/.tmux.conf
