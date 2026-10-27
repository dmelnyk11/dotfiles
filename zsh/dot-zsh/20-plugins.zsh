# --- Sheldon Plugin Manager & Completion System ---
if (( $+commands[sheldon] )); then
  eval "$(sheldon source)"
else
  autoload -Uz compinit && compinit -C -u
fi

# Case-insensitive & menu-driven completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
