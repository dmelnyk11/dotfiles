#!/usr/bin/env bash
# Setup Transmission VPN environment, icon, systemd daemon, and desktop database
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$HOME/.config/transmission-vpn/.env"
ENV_EXAMPLE="$DOTFILES_DIR/config/transmission-vpn/.env.example"
ICON_DST="$HOME/.local/share/icons/transmission-vpn.svg"
SYSTEM_SVG="/usr/share/icons/hicolor/scalable/apps/transmission-qt.svg"

if [[ ! -f "$ENV_FILE" && -f "$ENV_EXAMPLE" ]]; then
  echo "[Transmission VPN] Creating default .env at $ENV_FILE"
  cp "$ENV_EXAMPLE" "$ENV_FILE"
fi

if [[ ! -f "$ICON_DST" && -f "$SYSTEM_SVG" ]]; then
  cp "$SYSTEM_SVG" "$ICON_DST"
fi

if command -v systemctl &>/dev/null; then
  systemctl --user daemon-reload 2>/dev/null || true
fi

if command -v update-desktop-database &>/dev/null; then
  update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
fi
