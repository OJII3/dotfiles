{ pkgs, ... }: {
	programs.git = {
		enable = true;
		userName = "ojii3";
	};

	programs.gh = {
		enable = true;
		extensions = with pkgs; [gh-markdown-preview gh-dash];
		settings = {
			editor = "nvim";
		};
	};
}
