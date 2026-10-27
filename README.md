# Dotfiles

Personal dotfiles managed declaratively with [Dotbot](https://github.com/anishathalye/dotbot).

## Quick Start

```bash
./install
```

To install all recommended modern CLI tools on Arch Linux:

```bash
./scripts/install_packages.sh --install
```

## Structure

- `install` & `install.conf.yaml`: Dotbot bootstrap script and declarative link/shell configuration.
- `zsh/`: Modular Zsh configuration (`10-options.zsh`, `20-plugins.zsh`, `30-alias.zsh`, `40-interactive.zsh`).
- `tmux/`: Tmux configuration with TPM submodule.
- `config/`: Application configurations:
  - `atuin/`: Atuin SQLite shell history configuration.
  - `ghostty/` & `kitty/`: Terminal emulators.
  - `git/`: Git configuration with `delta` side-by-side syntax diffs.
  - `nvim/`: Neovim configuration (submodule).
  - `sheldon/`: Fast Rust-based Zsh plugin manager (`plugins.toml`).
  - `starship.toml`: Cross-shell prompt configuration.
  - `yazi/`: Terminal file manager configuration.
  - `transmission-vpn/` & `systemd/`: Gluetun + Transmission Docker Compose service.
- `scripts/`:
  - `kde_settings.sh`: Declarative KDE Plasma 6 settings and shortcuts using `kwriteconfig6`.
  - `install_packages.sh`: Package checker & installer for Arch Linux.
  - `setup_transmission_vpn.sh` & `transmission-vpn-launch.sh`: Transmission VPN helpers.

## Modern CLI Stack

| Tool | Purpose |
| :--- | :--- |
| **Sheldon** | Fast, declarative Zsh plugin manager |
| **Starship** | Fast, customizable Rust prompt |
| **Atuin** | Magical shell history with SQLite search |
| **eza** | Modern `ls` replacement with icons and Git status |
| **bat** | `cat` clone with syntax highlighting and Git integration |
| **fd** & **ripgrep** | Fast alternatives to `find` and `grep` (integrated with `fzf`) |
| **zoxide** | Smarter `cd` command |
| **delta** | Syntax-highlighting pager for `git diff` |
| **ouch** | Painless compression and decompression (`extract` / `compress`) |
| **yazi** | Blazing fast terminal file manager (`y` wrapper cds on exit) |
| **lazygit** | Terminal UI for Git (`lg`) |
| **btop** & **fastfetch** | System resource monitor and system info |
