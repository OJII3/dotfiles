{
  imports = [ ./. ];
  homebrew = {
    enable = true;
    onActivation = {
      upgrade = true;
      autoUpdate = false;
      cleanup = "uninstall";
    };
    casks = [
      "Figma"
      "SpaceId"
      "chatgpt"
      "discord"
      "firefox"
      "fork"
      "ghostty"
      "logi-options+"
      "ltspice"
      "obs"
      "raycast"
      "scroll-reverser"
      "steam"
      "unity-hub"
      "visual-studio-code"
    ];
    masApps = {
      # "bitwarden" = 1352778147;
    };
  };
}
