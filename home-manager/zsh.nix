{ pkgs, config, ...}: {
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

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
	};

  programs.starship.enable = true;
}
