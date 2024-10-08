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

export OPENAI_API_KEY=`cat ~/.secrets/openai`
export GEM_HOME="$HOME/gems"
export PLAYDATE_SDK_PATH="$HOME/Tools/PlaydateSDK-2.5.0"
export PATH="$HOME/gems/bin:$PLAYDATE_SDK_PATH/bin:$HOME/.cargo/bin:$HOME/.local/bin/:$HOME/Tools/PlaydateSDK-2.5.0/bin:$PATH"

# ZVM
export ZVM_INSTALL="$HOME/.zvm/self"
export PATH="$PATH:$HOME/.zvm/bin"
export PATH="$PATH:$ZVM_INSTALL/"

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

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

alias cc="xclip -selection clipboard"
alias cv="xclip -o -selection clipboard"

alias vim="nvim"

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
alias gs="git status"
alias gl="git log"
alias glp="git log -p"
alias gd="git diff"
alias gds="git diff --staged"
function gpu() {
  check_keys && git push -u origin $(git rev-parse --abbrev-ref HEAD)
}

alias lg="lazygit"

alias xsc="xclip -sel clip"
alias v='fd --type f --hidden --exclude .git | fzf-tmux -p --reverse | xargs --no-run-if-empty nvim'
alias biggest="du -aBm . 2>/dev/null | sort -nr | head -n 10"

eval $(ssh-agent) > /dev/null

# History config
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
alias ls="ls --color"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
source /usr/share/nvm/init-nvm.sh

alias conv-webm="for i in *.mkv; do ffmpeg -i "$i" -c:v libvpx-vp9 -crf 30 -b:v 0 -b:a 128k -c:a libopus \"${i%.*}.webm\"; done"

# pnpm
export PNPM_HOME="/home/milan/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
