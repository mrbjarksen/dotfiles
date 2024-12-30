# ------ General QoL ------ #

# Aliases
alias ls='ls --color -Fv'
alias ll='ls --color -AFlvh'
alias vim=nvim
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# Options
setopt AUTO_CD
setopt LIST_PACKED
setopt INTERACTIVE_COMMENTS
unsetopt BEEP

# Color theme for `ls' (through `vivid')
LS_COLORS=$(vivid generate one-dark)

# Disable highlight when pasting
zsh_highlight+=(paste:none)

# Handler for unknown command (using `pkgfile')
source /usr/share/doc/pkgfile/command-not-found.zsh

# ------ Vi mode ------ #

bindkey -v '^?' backward-delete-char

# Set cursor type depending on mode
function cursor-type () {
  case $KEYMAP in
    vicmd|visual) echo '\e[1 q';;
    *)            echo '\e[5 q';;
  esac
}

# Get the current mode as string
function keymap-str () {
  case $KEYMAP in
    viins|main)  echo '%K{green} %F{b}INSERT%f %k';;
    vicmd)       echo '%K{blue} %F{b}NORMAL%f %k';;
    visual)      echo '%K{yellow} %F{b}VISUAL%f %k';;
    *)           echo ''
  esac
}


# ------ Completion ------ #

autoload -Uz compinit
compinit

zstyle ':completion:*' menu select


# ------ History ------ #

# Options
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS

# History file
HISTFILE=$XDG_STATE_HOME/zsh/.history
HISTSIZE=1000000
SAVEHIST=$HISTSIZE

# History search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -- '^[[A' up-line-or-beginning-search
bindkey -- '^[[B' down-line-or-beginning-search
bindkey -a 'k' up-line-or-beginning-search
bindkey -a 'j' down-line-or-beginning-search


# ------ Prompt ------ #

setopt PROMPT_SUBST

autoload -U colors
colors

# Git information
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '^'
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
+vi-git-untracked () {
  [[ -n $(git ls-files --others --exclude-standard) ]] && hook_com[unstaged]+='+'
}
zstyle ':vcs_info:git*' formats ' %F{yellow}(%c%b%u%)%f'
precmd () { vcs_info }

# Terminalparty (custom)
#PROMPT=' %0(?.%F{green}.%F{red})%(!.#.$promptstr)%f '
#RPROMPT='%2~${vcs_info_msg_0_} %F{blue}%M%f'
#function zle-line-init zle-keymap-select () {
#  print -rn -- ( cursor-type )
#}

# New theme (working title)
PROMPT='%F{blue}%2~%f${vcs_info_msg_0_} %0(?.%F{green}.%F{red})%#%f '
function zle-keymap-select zle-line-init {
  RPROMPT='$(keymap-str)'
  zle && zle reset-prompt
  print -rn -- $(cursor-type)
}
zle-line-init
setopt TRANSIENT_RPROMPT
ZLE_RPROMPT_INDENT=0

zle -N zle-line-init
zle -N zle-keymap-select


# ------ Plugins ------ #

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

