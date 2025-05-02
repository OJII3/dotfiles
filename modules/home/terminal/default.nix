{ ... }: {
  imports = [
    ./config.nix
  ];
  programs.kitty.enable = true;
  programs.ghostty.enable = true;
  programs.wezterm.enable = true; # better then kitty for SSH
}
