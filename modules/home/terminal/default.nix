{ ... }: {
  imports = [
    ./config.nix
  ];
  programs.kitty.enable = true;
  programs.ghostty.enable = true;
}
