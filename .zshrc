#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#   Milan Gruner <milangruner@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

EDITOR="vim"

export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/milan/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

alias c="xclip -selection clipboard"
alias v="xclip -o"

alias vim="lvim"

check_keys() {
  if ssh-add -l | grep -q "no identities"; then
    ssh-add
  fi
}

alias ga="git add"
alias gc="git commit"
alias gca="git commit --amend"
alias gpl="check_keys && git pull"
alias gp="check_keys && git push"
alias gco="git checkout"
alias gcob="git checkout -b"
alias gpu="check_keys && git push -u origin"
alias gs="git status"
alias gl="git log"
alias glp="git log -p"
alias gd="git diff"
alias gds="git diff --staged"

alias xsc="xclip -sel clip"

alias v='fd --type f --hidden --exclude .git | fzf-tmux -p --reverse | xargs lvim'

eval $(ssh-agent) > /dev/null

eval "$(zoxide init zsh)"

