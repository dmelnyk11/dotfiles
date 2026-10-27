#!/usr/bin/env bash
# Install or check modern CLI dependencies
set -euo pipefail

PACKAGES=(
  openssh
  github-cli
  zsh
  tmux
  neovim
  sheldon
  starship
  atuin
  eza
  zoxide
  fzf
  fd
  ripgrep
  bat
  git-delta
  ouch
  yazi
  lazygit
  btop
  fastfetch
  direnv
)

missing=()
for pkg in "${PACKAGES[@]}"; do
  if command -v pacman &>/dev/null; then
    if ! pacman -Qi "$pkg" &>/dev/null; then
      missing+=("$pkg")
    fi
  fi
done

if [[ ${#missing[@]} -eq 0 ]]; then
  echo "[Packages] All recommended CLI packages are installed!"
  exit 0
fi

echo "[Packages] Missing recommended packages: ${missing[*]}"
if [[ "${1:-}" == "--install" ]] && command -v pacman &>/dev/null; then
  sudo pacman -S --needed "${missing[@]}"
else
  echo "[Packages] Run 'sudo pacman -S --needed ${missing[*]}' (or './scripts/install_packages.sh --install') to install them."
fi
