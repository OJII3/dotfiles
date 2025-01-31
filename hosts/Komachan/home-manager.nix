{ inputs, pkgs, ... }: {
  imports = [
    ../../home-manager/apps.nix
    ../../home-manager/browser.nix
    ../../home-manager/hyprland.nix
    ../../home-manager/dev.nix
    ../../home-manager/direnv.nix
    ../../home-manager/fcitx.nix
    ../../home-manager/git.nix
    ../../home-manager/neovim.nix
    ../../home-manager/network.nix
    ../../home-manager/terminal.nix
    ../../home-manager/zsh.nix
    ../../home-manager/games.nix
  ];

  # add laptop specific configuration
  wayland.windowManager.hyprland.extraConfig = ''
    exec-once = hypridle
  '';
}
