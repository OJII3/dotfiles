{ inputs, pkgs, ... }: {
  imports = [
    ../../home-manager/apps.nix
    ../../home-manager/browser.nix
    ../../home-manager/desktop.nix
    ../../home-manager/dev.nix
    ../../home-manager/direnv.nix
    ../../home-manager/fcitx.nix
    ../../home-manager/git.nix
    ../../home-manager/neovim.nix
    ../../home-manager/network.nix
    ../../home-manager/terminal.nix
    ../../home-manager/zsh.nix
  ];

  # override
  wayland.windowManager.hyprland =
    {
      extraConfig = ''
        ${builtins.readFile ../../home/.config/hypr/hyprland/env.conf}
        ${builtins.readFile ../../home/.config/hypr/hyprland/devices.conf}
        ${builtins.readFile ../../home/.config/hypr/hyprland/execs.conf}
        ${builtins.readFile ../../home/.config/hypr/hyprland/general.conf}
        ${builtins.readFile ../../home/.config/hypr/hyprland/keybinds.conf}
        ${builtins.readFile ../../home/.config/hypr/hyprland/rules.conf}
        exec-once = hypridle
      '';
    };
}
