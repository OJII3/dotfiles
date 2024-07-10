{ pkgs, ...}: {
	programs.zsh = {
		enable = true;
		autocd = true;
		enableCompletion = true;
		autosuggestion.enable = true;
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
  programs.starship.enable = true;
}
