{ pkgs, ... }: {
  home.packages = with pkgs; [
    gcc
    gnumake
  ];
  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    globalConfig = {
      tools = {
        bun = "latest";
      };
    };
  };
}
