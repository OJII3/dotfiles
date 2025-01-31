{ pkgs, ... }: {
  home.packages = with pkgs; [
    kdePackages.krdp
  ];
  programs.plasma = {
    enable = true;
    hotkeys.commands = {
      "ghostty" = {
        commands = "ghostty";
        key = "Super+Enter";
      };
    };
  };
}
