{ inputs, pkgs, ... }: {
  imports = [
    ../../home-manager/assets.nix
    ../../home-manager/browser.nix
    ../../home-manager/dev.nix
    ../../home-manager/direnv.nix
    ../../home-manager/git.nix
    ../../home-manager/neovim.nix
    ../../home-manager/terminal/config.nix
    ../../home-manager/zsh.nix
  ];

  programs.kitty.enable = true;
  home.packages = with pkgs; [
    raycast
  ];

  programs.gpg = {
    enable = true;
  };
}
