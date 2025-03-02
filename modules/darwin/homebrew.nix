{
  homebrew = {
    enable = true;
    casks = [
      "aldente"
      "blender"
      "ghostty"
      "jetbrains-toolbox"
      "karabiner-elements"
      "unity-hub"
      "parsec"
      "visual-studio-code"
    ];
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
  };
}
