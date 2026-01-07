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
      "SpaceId"
      "affinity"
      "chatgpt"
      "discord"
      "docker-desktop"
      "figma"
      "firefox"
      "fork"
      "ghostty"
      "logi-options+"
      "ltspice"
      "obs"
      "raycast"
      "scroll-reverser"
      "slack"
      "steam"
      "unity-hub"
      "visual-studio-code"
    ];
    masApps = {
      # "bitwarden" = 1352778147;
      tailscale = 1475387142;
      cloudflare-one-agent = 6443476492;
    };
  };
}
