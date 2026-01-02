{ config, lib, pkgs, ... }:
let
  vivaldiSettingsFile = ./vivaldi-settings.json;
  vivaldiBookmarksFile = ./Bookmarks;

  # Find the Vivaldi profile directory (Profile 1 or Default)
  findProfileScript = ''
    if [ -d "$HOME/.config/vivaldi/Profile 1" ]; then
      echo "$HOME/.config/vivaldi/Profile 1"
    elif [ -d "$HOME/.config/vivaldi/Default" ]; then
      echo "$HOME/.config/vivaldi/Default"
    else
      echo ""
    fi
  '';
in
{
  home.packages = with pkgs; [ jq ];

  # Store settings in a known location for the activation script
  home.file.".config/vivaldi-dotfiles/vivaldi-settings.json".source = vivaldiSettingsFile;
  home.file.".config/vivaldi-dotfiles/Bookmarks".source = vivaldiBookmarksFile;

  home.activation.vivaldiConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    PROFILE_DIR=$(${findProfileScript})

    if [ -z "$PROFILE_DIR" ]; then
      echo "Vivaldi profile not found. Skipping config merge (will apply on next activation after first Vivaldi launch)."
      exit 0
    fi

    # Check if Vivaldi is running
    if ${pkgs.procps}/bin/pgrep -x "vivaldi" > /dev/null 2>&1; then
      echo "Warning: Vivaldi is running. Settings will be applied on next activation when Vivaldi is closed."
      exit 0
    fi

    PREFS_FILE="$PROFILE_DIR/Preferences"
    BOOKMARKS_FILE="$PROFILE_DIR/Bookmarks"
    DOTFILES_DIR="$HOME/.config/vivaldi-dotfiles"

    # Merge Preferences
    if [ -f "$PREFS_FILE" ]; then
      echo "Merging Vivaldi settings..."
      ${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$PREFS_FILE" "$DOTFILES_DIR/vivaldi-settings.json" > "$PREFS_FILE.tmp"
      if [ $? -eq 0 ]; then
        mv "$PREFS_FILE.tmp" "$PREFS_FILE"
        echo "Vivaldi settings merged successfully."
      else
        echo "Error merging Vivaldi settings. Keeping original."
        rm -f "$PREFS_FILE.tmp"
      fi
    else
      echo "Vivaldi Preferences file not found. Skipping settings merge."
    fi

    # Copy Bookmarks (with backup)
    if [ -f "$DOTFILES_DIR/Bookmarks" ]; then
      if [ -f "$BOOKMARKS_FILE" ]; then
        cp "$BOOKMARKS_FILE" "$BOOKMARKS_FILE.bak"
      fi
      cp "$DOTFILES_DIR/Bookmarks" "$BOOKMARKS_FILE"
      echo "Vivaldi bookmarks restored."
    fi
  '';
}
