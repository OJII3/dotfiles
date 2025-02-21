{ inputs, pkgs, ... }: {
  imports = [
    ../../home-manager/direnv.nix
    ../../home-manager/git.nix
    ../../home-manager/neovim.nix
    ../../home-manager/zsh.nix
    ../../home-manager/dev.nix
  ];

  programs.google-chrome.enable = true;
  home.packages = with pkgs; [
    kitty
    raycast
  ];

  programs.gpg = {
    enable = true;
  };
}
