export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_DATA_DIRS=/usr/local/share:/usr/share
export XDG_CONFIG_DIRS=/etc/xdg

export TERM=xterm-kitty
export VISUAL=nvim
export EDITOR=nvim
export BROWSER=$(if [[ -n $DISPLAY ]]; then echo 'firefox'; else echo 'elinks'; fi)

typeset -U PATH path
export PATH="$HOME/.local/bin:$PATH"

source $HOME/.ghcup/env
