{ pkgs, ... }: {
	programs.git = {
		enable = true;
		userName = "ojii3";
    userEmail = "84656786+OJII3@users.noreply.github.com";
    aliases = {
      c = "commit -m";
      co = "checkout";
      s = "status";
      pl = "pull";
      ph = "push";
      b = "branch";
      d = "diff";
      l = "log";
      a = "add";
      pr = "!gh pr";
      repo = "!gh repo";
    };
    extraConfig = {
      push = { autoSetupRemote = true; };
    };
	};

	programs.gh = {
		enable = true;
		extensions = with pkgs; [gh-markdown-preview gh-dash gh-copilot];
		settings = {
			editor = "nvim";
		};
	};

}
