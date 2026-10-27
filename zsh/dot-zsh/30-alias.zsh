# --- Core File Listing (eza) ---
if (( $+commands[eza] )); then
  alias ls='eza --icons=auto --group-directories-first'
  alias l='eza -l --icons=auto --group-directories-first --git'
  alias la='eza -la --icons=auto --group-directories-first --git'
  alias lt='eza --tree --level=2 --icons=auto'
else
  alias ls='ls --color=auto'
  alias l='ls -lh --color=auto'
  alias la='ls -lAh --color=auto'
fi

# --- Modern CLI Replacements ---
if (( $+commands[bat] )); then
  alias cat='bat --paging=never'
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT="-c"
fi

if (( $+commands[ouch] )); then
  alias extract='ouch decompress'
  alias compress='ouch compress'
else
  # Fallback archive extraction
  extract() {
    if [ -f "$1" ]; then
      case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz)  tar xzf "$1" ;;
        *.bz2)     bunzip2 "$1" ;;
        *.rar)     unrar x "$1" ;;
        *.gz)      gunzip "$1"  ;;
        *.tar)     tar xf "$1"  ;;
        *.zip)     unzip "$1"   ;;
        *)         echo "'$1' cannot be extracted via extract()" ;;
      esac
    else
      echo "'$1' is not a valid file"
    fi
  }
fi

# --- Editor & Tools ---
alias v='nvim'
alias lg='lazygit'
alias top='btop'
alias ff='fastfetch'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -I'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias sudo='sudo ' # Enable aliases for sudo
alias m='make'
alias mar='make run'
alias c="code --no-sandbox"
alias nano='nvim'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias open='xdg-open'

# --- Git ---
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'

# --- Arch Specific ---
if [ -f /etc/arch-release ]; then
  alias pacman='sudo pacman'
  alias update='sudo pacman -Syu'
fi

# --- Utility Functions ---
# Create a directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Yazi wrapper that changes current working directory on exit
if (( $+commands[yazi] )); then
  y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
  }
fi
