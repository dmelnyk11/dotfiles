# LLM Dotfiles Project Guidelines

When interacting with this repository, please adhere to the following rules to ensure stability, consistency, and proper synchronization across the project.

## 1. Project Structure & Symlinking (Dotbot)
- This project uses **Dotbot** (`./install` and `install.conf.yaml`) to manage dotfiles.
- Packages are organized in root directories (`zsh/`, `tmux/`, `config/`, `local/`, `scripts/`).
- Do **not** symlink entire parent directories like `~/.config/systemd` or `~/.local/share/applications` if applications write runtime state into them. Link the specific files or leaf directories in `install.conf.yaml`.
- If you add a new configuration module (e.g., `config/some-tool`), add its link mapping under the `- link:` section of `install.conf.yaml`.

## 2. Managing Dependencies (`scripts/install_packages.sh`)
- `scripts/install_packages.sh` tracks recommended CLI tools and packages.
- If you add a new tool or command alias (e.g., `eza`, `zoxide`, `starship`, `sheldon`, `atuin`, `yazi`, `ouch`, `git-delta`), make sure to add it to the `PACKAGES` array in `scripts/install_packages.sh`.
- Ensure all setup scripts in `scripts/` remain idempotent (safe to run multiple times via `./install`).

## 3. Shell Configuration (`zsh`)
- Zsh plugins are managed declaratively with **Sheldon** (`config/sheldon/plugins.toml`) and loaded in `zsh/dot-zsh/20-plugins.zsh`.
- Prompt configuration is managed with **Starship** (`config/starship.toml`).
- Alias and function changes should go into `zsh/dot-zsh/30-alias.zsh`.
- Interactive tool hooks (`fzf`, `zoxide`, `direnv`, `atuin`, `starship`) go into `zsh/dot-zsh/40-interactive.zsh`.
- Keep initialization scripts fast. Heavy or interactive initializations must be skipped when the shell is loaded by an AI Agent (keep the `$GEMINI_CLI` / `$ANTIGRAVITY_AGENT` early return in `zsh/dot-zshrc`).

## 4. KDE Plasma 6 Configuration (`scripts/kde_settings.sh`)
- KDE Plasma settings are managed declaratively using `kwriteconfig6` inside `scripts/kde_settings.sh` (rather than symlinking noisy KDE `.rc` files).
- When adding or modifying KDE Plasma / KWin / shortcut settings, add the corresponding `kwriteconfig6` command to `scripts/kde_settings.sh`.

## 5. Updates & Maintenance
- Avoid hardcoding absolute paths or usernames (like `/home/dmelnyk`); use `$HOME` and check if commands exist (`(( $+commands[tool] ))` in Zsh or `command -v tool &>/dev/null` in Bash) before initializing or aliasing them.
