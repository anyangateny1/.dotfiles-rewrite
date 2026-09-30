#!/usr/bin/env bash
set -euo pipefail

if ! command -v kwriteconfig6 >/dev/null 2>&1; then
    printf '[kde] skipped (kwriteconfig6 not found)\n'
    exit 0
fi

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
data_home="${XDG_DATA_HOME:-${HOME}/.local/share}"
switcher_dir="${data_home}/kwin/tabbox/gnome_outline"

# Install a switcher which draws only a thin outline around the candidate.
install -Dm644 "${script_dir}/window-switcher/gnome-outline/metadata.json" \
    "${switcher_dir}/metadata.json"
install -Dm644 "${script_dir}/window-switcher/gnome-outline/contents/ui/main.qml" \
    "${switcher_dir}/contents/ui/main.qml"

# Cycle through windows with only a thin outline as the indicator.
kwriteconfig6 --file kglobalshortcutsrc --group kwin \
    --key 'Window Lower' --notify 'none,none,Lower Window'
kwriteconfig6 --file kglobalshortcutsrc --group kwin \
    --key 'Walk Through Windows Alternative' --notify \
    'Alt+Esc,none,Walk Through Windows Alternative'
kwriteconfig6 --file kglobalshortcutsrc --group kwin \
    --key 'Walk Through Windows Alternative (Reverse)' --notify \
    'Alt+Shift+Esc,none,Walk Through Windows Alternative (Reverse)'

# KWin reads the delay from TabBox for both switchers (including Alt+Tab).
kwriteconfig6 --file kwinrc --group TabBox \
    --key DelayTime --type int --notify 0
kwriteconfig6 --file kwinrc --group TabBoxAlternative \
    --key HighlightWindows --type bool --notify false
kwriteconfig6 --file kwinrc --group TabBoxAlternative \
    --key ShowTabBox --type bool --notify true
kwriteconfig6 --file kwinrc --group TabBoxAlternative \
    --key LayoutName --notify gnome_outline

# Make the focused window visually distinct without manipulating the other
# windows specifically for the duration of the Alt+Escape switcher.
kwriteconfig6 --file kwinrc --group Plugins \
    --key diminactiveEnabled --type bool --notify true
kwriteconfig6 --file kwinrc --group Effect-diminactive \
    --key Strength --type int --notify 10

if command -v qdbus6 >/dev/null 2>&1; then
    qdbus6 org.kde.KWin /KWin org.kde.KWin.reconfigure >/dev/null 2>&1 || true
fi

printf '[kde] Alt+Escape outline window cycling configured\n'
