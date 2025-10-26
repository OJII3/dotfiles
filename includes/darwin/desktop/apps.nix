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
      "chatgpt"
      "discord"
      "firefox"
      "fork"
      "ghostty"
      "logi-options+"
      "ltspice"
      "scroll-reverser"
      "steam"
      "visual-studio-code"
      # "wacom-tablet" older version of driver is unavailable from brew
    ];
    masApps = {
      # "bitwarden" = 1352778147;
    };
  };
}
