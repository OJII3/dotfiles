{ pkgs, ... }: {
  imports = [
    ../../modules/home
    ../../modules/home/ai/claude.nix
    ../../modules/home/apps/darwin.nix
    ../../modules/home/darwin/aerospace
    ../../modules/home/darwin/jankyborders
    ../../modules/home/darwin/kdeconnect
    ../../modules/home/darwin/skhd
    ../../modules/home/dev
    ../../modules/home/dev/mise.nix
    ../../modules/home/direnv.nix
    ../../modules/home/git
    ../../modules/home/gpg
    ../../modules/home/neovim
    ../../modules/home/sops.nix
    ../../modules/home/terminal/kitty
    ../../modules/home/zsh
  ];

  programs.zsh.initContent = ''
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';
}
