cd ~/dotfiles

stow -t ~/.config -S nvim
stow -t ~/.config -S yazi
stow -t ~/.config -S ghostty
stow tmux

tmux source-file ~/.tmux.conf
