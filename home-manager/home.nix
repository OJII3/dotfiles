{ pkgs, ... }: {
	home = rec {
		username = "ojii3";
		homeDirectory = "/home/${username}";
		stateVersion = "24.11";
	};
	programs.home-manager.enable = true;
	home.packages = with pkgs; [
		bat
		bottom
		httpie
		ripgrep
		pingu
    fzf
    tig
    delta
    yazi
    tmux
    imagemagick
    fastfetch
    termpdfpy
	];
  imports = [
    ./git.nix
    ./neovim.nix
    ./dev.nix
    ./browser.nix
    ./direnv.nix
    ./apps.nix
    ./desktop.nix
    ./zsh.nix
  ];
}
