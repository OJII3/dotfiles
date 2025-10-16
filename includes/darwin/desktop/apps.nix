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
      "chatgpt"
      "firefox"
      "fork"
      "ghostty"
      "logi-options+"
      "ltspice"
      "scroll-reverser"
      "steam"
      "visual-studio-code"
      # "wacom-tablet"
    ];
    masApps = {
      "bitwarden" = 1352778147;
    };
  };
}
