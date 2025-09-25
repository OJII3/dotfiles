{
  imports = [ ../default.nix ];
  programs.wezterm.enable = true; # better then kitty for SSH
  home.file.".config/wezterm" = {
    source = ./.;
    recursive = true;
  };
}
