XDG_CONFIG_HOME=$HOME/.config
XDG_CACHE_HOME=$HOME/.cache
XDG_DATA_HOME=$HOME/.local/share
XDG_STATE_HOME=$HOME/.local/state
XDG_DATA_DIRS=/usr/local/share:/usr/share
XDG_CONFIG_DIRS=/etc/xdg

QT_SCALE_FACTOR=2

TERM=xterm-kitty
VISUAL=nvim
EDITOR=nvim
BROWSER=$(if [[ -n $DISPLAY ]]; then echo 'firefox'; else echo 'elinks'; fi)
typeset -U PATH path

path=($HOME/.local/bin "$path[@]")
export PATH
