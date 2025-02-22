{ inputs, pkgs, ... }: {
  imports = [
    ../../home-manager/terminal

    ../../home-manager/apps.nix
    ../../home-manager/assets.nix
    ../../home-manager/browser.nix
    ../../home-manager/desktop/hyprland.nix
    ../../home-manager/desktop/theme.nix
    ../../home-manager/dev.nix
    ../../home-manager/direnv.nix
    ../../home-manager/fcitx.nix
    ../../home-manager/git.nix
    ../../home-manager/kdewallet.nix
    ../../home-manager/neovim.nix
    ../../home-manager/network.nix
    ../../home-manager/zsh.nix
  ];

  # add laptop specific configuration
  wayland.windowManager.hyprland.extraConfig = ''
    exec-once = hypridle
  '';
}
