{
  homebrew = {
    enable = true;
    masApps = {
      # "KDE Connect" = 1580245991;
    };
    brews = [
      "gcc"
    ];
    casks = [
      "bitwarden"
      "blender"
      "blockbench"
      "chatgpt"
      "discord"
      "ghostty"
      "jetbrains-toolbox"
      "karabiner-elements"
      "logi-options+"
      "minecraft"
      "moonlight"
      "obs"
      "parsec"
      "scroll-reverser"
      "spaceid"
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
