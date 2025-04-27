{
  homebrew = {
    enable = true;
    masApps = {
      "KDE Connect" = 1580245991;
    };
    casks = [
      "blender"
      "blockbench"
      "discord"
      "ghostty"
      "jetbrains-toolbox"
      "karabiner-elements"
      "logi-options+"
      "minecraft"
      "obs"
      "parsec"
      "scroll-reverser"
      "spaceid"
      "unity-hub"
      "visual-studio-code"
      "wireshark"
    ];
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
  };
}
