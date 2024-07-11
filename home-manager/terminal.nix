{ pkgs, ... }: {
  home.packages = with pkgs; [
    kitty
  ];
  programs.kitty = {
    enable = true;
    theme = "Tokyo Night";
    font = "HackGen35 Console NF";
  };
}
