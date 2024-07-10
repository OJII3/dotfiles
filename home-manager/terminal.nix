{ pkgs, ... }: {
  home.packages = with pkgs; [
    kitty
  ];
  programs.kitty = {
    enable = true;
    theme = "Tokyo Night";
  };
  programs.starship.enable = true;
}
