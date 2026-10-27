# --- FZF + fd / bat Integration ---
if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix --hidden --follow --exclude .git'
fi

if (( $+commands[fzf] )); then
  # Modern fzf (>= 0.48) built-in shell integration, with distro file fallbacks
  if fzf --zsh &>/dev/null; then
    source <(fzf --zsh)
  else
    [ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
    [ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
    [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
    [ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
  fi
fi

# --- Zoxide ---
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh --cmd cd)"
fi

# --- Direnv ---
if (( $+commands[direnv] )); then
  eval "$(direnv hook zsh)"
fi

# --- Atuin (Shell History) ---
if (( $+commands[atuin] )); then
  eval "$(atuin init zsh)"
fi

# --- Starship Prompt ---
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi
