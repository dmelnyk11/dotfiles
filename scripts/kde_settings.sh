#!/usr/bin/env bash
# Declarative KDE Plasma 6 Settings via kwriteconfig6 & KWin DBus
set -euo pipefail

if ! command -v kwriteconfig6 &>/dev/null; then
  echo "[KDE Settings] kwriteconfig6 not found (skipping KDE Plasma configuration)."
  exit 0
fi

echo "[KDE Settings] Applying KDE Plasma 6 settings..."

# --- Theme, Look & Feel, Default Apps (kdeglobals) ---
kwriteconfig6 --file kdeglobals --group KDE --key LookAndFeelPackage "org.kde.breezedark.desktop"
kwriteconfig6 --file kdeglobals --group KDE --key AutomaticLookAndFeel true
kwriteconfig6 --file kdeglobals --group KDE --key AnimationDurationFactor 0
kwriteconfig6 --file kdeglobals --group General --key BrowserApplication "google-chrome.desktop"
kwriteconfig6 --file kdeglobals --group General --key TerminalApplication "ghostty"
kwriteconfig6 --file kdeglobals --group General --key TerminalService "com.mitchellh.ghostty.desktop"

# --- Virtual Desktops & KWin (kwinrc + VirtualDesktopManager DBus) ---
TARGET_DESKTOPS=5
TARGET_ROWS=1

kwriteconfig6 --file kwinrc --group Desktops --key Number "$TARGET_DESKTOPS"
kwriteconfig6 --file kwinrc --group Desktops --key Rows "$TARGET_ROWS"
kwriteconfig6 --file kwinrc --group Plugins --key slideEnabled false
kwriteconfig6 --file kwinrc --group Xwayland --key Scale 1.0

if command -v qdbus6 &>/dev/null; then
  current_desktops=$(qdbus6 org.kde.KWin /VirtualDesktopManager org.kde.KWin.VirtualDesktopManager.count 2>/dev/null || echo 1)
  while [[ "$current_desktops" -lt "$TARGET_DESKTOPS" ]]; do
    next_num=$((current_desktops + 1))
    qdbus6 org.kde.KWin /VirtualDesktopManager org.kde.KWin.VirtualDesktopManager.createDesktop "$current_desktops" "Desktop $next_num" >/dev/null 2>&1 || break
    current_desktops=$((current_desktops + 1))
  done
  qdbus6 org.kde.KWin /VirtualDesktopManager org.freedesktop.DBus.Properties.Set org.kde.KWin.VirtualDesktopManager rows "$TARGET_ROWS" >/dev/null 2>&1 || true
fi

# --- KRunner & Modifier-Only Meta Key (krunnerrc & kwinrc) ---
kwriteconfig6 --file krunnerrc --group General --key FreeFloating true
kwriteconfig6 --file kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.krunner,/App,,toggleDisplay"

# --- Dolphin File Manager (dolphinrc) ---
kwriteconfig6 --file dolphinrc --group MainWindow --key MenuBar "Disabled"
kwriteconfig6 --file dolphinrc --group "KFileDialog Settings" --key "Places Icons Auto-resize" false
kwriteconfig6 --file dolphinrc --group "KFileDialog Settings" --key "Places Icons Static Size" 22

# --- Notifications (plasmanotifyrc) ---
kwriteconfig6 --file plasmanotifyrc --group DoNotDisturb --key NotificationSoundsMuted true

# --- Global Shortcuts (kglobalshortcutsrc + live KGlobalAccel DBus registration) ---
for i in {1..5}; do
  kwriteconfig6 --file kglobalshortcutsrc --group plasmashell --key "activate task manager entry $i" "none,Meta+$i,Activate Task Manager Entry $i"
  kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Switch to Desktop $i" "Meta+$i,none,Switch to Desktop $i"
done

symbols=('!' '@' '#' '$' '%')
for i in {1..5}; do
  sym="${symbols[$((i-1))]}"
  kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Window to Desktop $i" "Meta+$sym,none,Window to Desktop $i"
done

kwriteconfig6 --file kglobalshortcutsrc --group plasmashell --key "activate application launcher" $'Meta+Space\tAlt+F1,none,Activate Application Launcher'
kwriteconfig6 --file kglobalshortcutsrc --group "org.kde.krunner.desktop" --key "_launch" $'Meta\tAlt+Space\tSearch\tAlt+F2,none,KRunner'

# Register shortcuts live in kwin_wayland's KGlobalAccel service via DBus
if command -v gdbus &>/dev/null && command -v python3 &>/dev/null; then
  python3 - <<'EOF' 2>/dev/null || true
import subprocess

META = 0x10000000
ALT = 0x08000000
KEY_META = 0x01000022
KEY_F1 = 0x01000030
KEY_F2 = 0x01000031
KEY_SPACE = 0x20
KEY_SEARCH = 0x01000092

def set_shortcut(comp, comp_friendly, action, action_friendly, keys):
    action_id = f'["{comp}", "{action}", "{comp_friendly}", "{action_friendly}"]'
    key_arr = "[" + ", ".join(str(k) for k in keys) + "]"
    subprocess.run([
        "gdbus", "call", "--session",
        "--dest", "org.kde.kglobalaccel",
        "--object-path", "/kglobalaccel",
        "--method", "org.kde.KGlobalAccel.setForeignShortcut",
        action_id, key_arr
    ], check=False, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

for i in range(1, 6):
    set_shortcut("plasmashell", "Plasma", f"activate task manager entry {i}", f"Activate Task Manager Entry {i}", [])
    set_shortcut("kwin", "KWin", f"Switch to Desktop {i}", f"Switch to Desktop {i}", [META | ord(str(i))])

symbols = ["!", "@", "#", "$", "%"]
for i, sym in enumerate(symbols, 1):
    set_shortcut("kwin", "KWin", f"Window to Desktop {i}", f"Window to Desktop {i}", [META | ord(sym)])

set_shortcut("plasmashell", "Plasma", "activate application launcher", "Activate Application Launcher", [META | KEY_SPACE, ALT | KEY_F1])
set_shortcut("org.kde.krunner.desktop", "KRunner", "_launch", "KRunner", [META | KEY_META, ALT | KEY_SPACE, KEY_SEARCH, ALT | KEY_F2])
EOF
fi

# --- Reload KDE Plasma / KWin Daemons ---
if command -v qdbus6 &>/dev/null; then
  qdbus6 org.kde.KWin /KWin reconfigure >/dev/null 2>&1 || true
fi

echo "[KDE Settings] Applied successfully!"
