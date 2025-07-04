{ ... }: {
  imports = [
    ../../modules/home
    ../../modules/home/dev.nix
    ../../modules/home/dev/mise.nix
    ../../modules/home/direnv.nix
    ../../modules/home/git
    ../../modules/home/gpg
    ../../modules/home/neovim
    ../../modules/home/sops.nix
    ../../modules/home/terminal/config.nix
    ../../modules/home/zsh
    ../../modules/home/ai/claude.nix
  ];

  programs.kitty.enable = true;
  programs.zsh.initContent = ''
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';
}
