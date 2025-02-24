{ pkgs, ... }: {
  home.packages =
    if pkgs.system == "aarch64-darwin"
    then
      with pkgs; [
        arc-browser
        raycast
      ]
    else
      [ ];
}
