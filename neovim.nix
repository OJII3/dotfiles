{ pkgs, lib, dotfiles, ... }: {
	programs.neovim = {
		enable = true;
		viAlias = true;
		
		# extraLuaConfig = builtins.readFile ./dotfiles/.config/nvim/init.lua;
	};

  home.file.".config/nvim" = {
    source = ./nvim;
    recursive = true;
  };
}
