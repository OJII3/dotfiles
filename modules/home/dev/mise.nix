{ ... }: {
  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    globalConfig = {
      tools = {
        bun = "latest";
      };
      plugins = {
        node = "https://github.com/asdf-vm/asdf-nodejs";
      };
    };
  };
}
