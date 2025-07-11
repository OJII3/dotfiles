{
  homebrew = {
    enable = true;
    masApps = {
      # "KDE Connect" = 1580245991;
      "xiaomi-interconnectivity" = 6673908449;
      "%E5%B4%A9%E5%A3%8A3rd" = 1172809651; # "崩坏3rd"
      "kindle" = 302584613;

    };
    brews = [
      "gcc"
    ];
    casks = [
      "bitwarden"
      "blender"
      "blockbench"
      "chatgpt"
      "cloudflare-warp"
      "discord"
      "docker"
      "firefox"
      "figma"
      "ghostty"
      "google-chrome"
      "jetbrains-toolbox"
      "logi-options+"
      "minecraft"
      "moonlight"
      "obs"
      "parsec"
      "scroll-reverser"
      "steam"
      "unity-hub"
      "visual-studio-code"
      "wezterm"
      "wireshark"
    ];
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
  };
}
