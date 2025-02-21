{ inputs, pkgs, ... }: {
  imports = [
    ../../home-manager/assets.nix
    ../../home-manager/direnv.nix
    ../../home-manager/git.nix
    ../../home-manager/neovim.nix
    ../../home-manager/zsh.nix
    ../../home-manager/dev.nix
    ../../home-manager/terminal/config.nix
  ];

  programs.kitty.enable = true;
  programs.google-chrome.enable = true;
  home.packages = with pkgs; [
    raycast
  ];

  programs.gpg = {
    enable = true;
  };
}
