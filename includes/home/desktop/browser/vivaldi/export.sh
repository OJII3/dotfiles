#!/usr/bin/env bash
# Export current Vivaldi settings to dotfiles
# Run this script after making changes in Vivaldi that you want to save

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Find profile directory
if [ -d "$HOME/.config/vivaldi/Profile 1" ]; then
  PROFILE_DIR="$HOME/.config/vivaldi/Profile 1"
elif [ -d "$HOME/.config/vivaldi/Default" ]; then
  PROFILE_DIR="$HOME/.config/vivaldi/Default"
else
  echo "Error: Vivaldi profile not found"
  exit 1
fi

echo "Exporting from: $PROFILE_DIR"

# Export settings (selected keys only)
jq '{
  vivaldi: {
    actions: .vivaldi.actions,
    toolbars: .vivaldi.toolbars,
    panels: .vivaldi.panels,
    theme: .vivaldi.theme,
    themes: .vivaldi.themes,
    tabs: .vivaldi.tabs,
    appearance: .vivaldi.appearance,
    startpage: .vivaldi.startpage,
    address_bar: .vivaldi.address_bar,
    status_bar: .vivaldi.status_bar
  }
}' "$PROFILE_DIR/Preferences" > "$SCRIPT_DIR/vivaldi-settings.json"

echo "Exported: vivaldi-settings.json"

# Export bookmarks
cp "$PROFILE_DIR/Bookmarks" "$SCRIPT_DIR/Bookmarks"
echo "Exported: Bookmarks"

echo "Done! Don't forget to commit the changes."
