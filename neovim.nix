{ pkgs, lib, ... }: {
	programs.neovim = {
		enable = true;
		viAlias = true;
		
		# extraLuaConfig = builtins.readFile ./dotfiles/.config/nvim/init.lua;
	};

  home.file.".config/nvim" = {
    source = ./dotfiles/.config/nvim;
    recursive = true;
  };
}
