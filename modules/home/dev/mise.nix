{ ... }: {
  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    globalConfig = {
      tools = {
        bun = "latest";
      };
      alias = {
        node = "https://github.com/asdf-vm/asdf-nodejs";
      };
    };
  };
}
