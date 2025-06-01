{
  homebrew = {
    enable = true;
    masApps = {
      # "KDE Connect" = 1580245991;
      "xiaomi-interconnectivity" = 6673908449;
      # "tailscale" = 1475387142;
      "%E5%B4%A9%E5%A3%8A3rd" = 1172809651;

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
      "ghostty"
      "google-chrome"
      "jetbrains-toolbox"
      "karabiner-elements"
      "logi-options+"
      "minecraft"
      "moonlight"
      "obs"
      "parsec"
      "scroll-reverser"
      "spaceid"
      "steam"
      "unity-hub"
      "visual-studio-code"
      "warp"
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
