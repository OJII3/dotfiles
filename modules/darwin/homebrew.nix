{
  homebrew = {
    enable = true;
    masApps = {
      # "KDE Connect" = 1580245991;
    };
    casks = [
      "minecraft"
      "blender"
      "blockbench"
      "discord"
      "ghostty"
      "jetbrains-toolbox"
      "karabiner-elements"
      "parsec"
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
