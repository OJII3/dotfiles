{
  homebrew = {
    enable = true;
    casks = [
      "minecraft"
      "blender"
      "discord"
      "ghostty"
      "jetbrains-toolbox"
      "karabiner-elements"
      "parsec"
      "unity-hub"
      "visual-studio-code"
    ];
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
  };
}
