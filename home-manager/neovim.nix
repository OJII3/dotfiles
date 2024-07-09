{ pkgs, lib, ... }: {
	programs.neovim = {
		enable = true;
		viAlias = true;

    extraPackages = with pkgs; [
      biome
      deno
      nodejs
      tree-sitter
      luarocks
      tinymist
      typst-lsp
      stylua
    ];

		# extraLuaConfig = builtins.readFile ./dotfiles/.config/nvim/init.lua;
	};

  home.file.".config/nvim" = {
    source = ./dotfiles/.config/nvim;
    recursive = true;
  };
}
