{ pkgs, ... }: {
	programs.git = {
		enable = true;
		userName = "ojii3";
    userEmail = "84656786+OJII3@users.noreply.github.com";
	};

	programs.gh = {
		enable = true;
		extensions = with pkgs; [gh-markdown-preview gh-dash];
		settings = {
			editor = "nvim";
		};
	};

}
