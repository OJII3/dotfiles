{ ... }:
{
  imports = [
    ../../includes/home
    ../../includes/home/apps/darwin.nix
    ../../includes/home/dev
    ../../includes/home/dev/ai/claude
    ../../includes/home/dev/ai/codex
    ../../includes/home/dev/ai/gemini
    ../../includes/home/dev/mise.nix
    ../../includes/home/direnv.nix
    ../../includes/home/git
    ../../includes/home/gpg
    ../../includes/home/helix.nix
    ../../includes/home/neovim
    ../../includes/home/sops.nix
    ../../includes/home/terminal/ghostty
    ../../includes/home/terminal/kitty
    ../../includes/home/vim
    ../../includes/home/zsh
  ];

  programs.zsh.initContent = ''
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';
}
