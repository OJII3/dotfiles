{ pkgs, ...}: {
	programs.zsh = {
		enable = true;
		autocd = true;
		enableCompletion = true;
		enableAutosuggestions = true;
		syntaxHighlighting.enable = true;
		shellAliases = {
			cat = "bat";
			grep = "rg";
			ls = "ls --color=auto";
			ll = "ls -l";
			la = "ls -a";
			g = "git";
			ya = "yazi";
		};
	};
}
