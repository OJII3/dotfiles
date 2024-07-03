{ pkgs, lib, ... }: {
	programs.neovim = {
		enable = true;
		viAlias = true;
		
		extraLuaConfig = builtins.readFile ~/.config/nvim/init.lua;
	};
}
