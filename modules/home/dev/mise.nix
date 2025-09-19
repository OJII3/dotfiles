{ ... }:
{
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
      settings = {
        idiomatic_version_file_enable_tools = [ "node" ];
      };
    };
  };
}
