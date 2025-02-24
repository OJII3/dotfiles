{
  homebrew = {
    enable = true;
    casks = [
      # list of packags that cannot be installed by nix
      "karabiner-elements"
      "blender"
      "unity-hub"
      "jetbrains-toolbox"
    ];
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
  };
}
